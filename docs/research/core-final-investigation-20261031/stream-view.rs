//! Checked composition of borrowed and owned JSON. Construction confers no validity.
use super::{CanonicalError, check_no_floats, contains_float, finish_digest};
use serde::ser::SerializeMap;
use serde::{Serialize, Serializer};
use serde_json::Value;
use sha2::{Digest, Sha256};
use std::collections::BTreeMap;
use std::io::{self, BufWriter, Write};

/// Internal cross-crate view; not part of the supported engine facade.
/// Objects compose fixed document fields while JSON leaves preserve their representation.
pub enum DocumentView<'a> {
    Borrowed(&'a Value),
    Owned(Value),
    Object(BTreeMap<&'a str, DocumentView<'a>>),
}

impl DocumentView<'_> {
    fn contains_float(&self) -> bool {
        match self {
            Self::Borrowed(value) => contains_float(value),
            Self::Owned(value) => contains_float(value),
            Self::Object(fields) => fields.values().any(Self::contains_float),
        }
    }

    fn check_no_floats(&self, path: &str) -> Result<(), CanonicalError> {
        match self {
            Self::Borrowed(value) => check_no_floats(value, path),
            Self::Owned(value) => check_no_floats(value, path),
            Self::Object(fields) => fields
                .iter()
                .try_for_each(|(key, value)| value.check_no_floats(&format!("{path}.{key}"))),
        }
    }
}

impl Serialize for DocumentView<'_> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        match self {
            Self::Borrowed(value) => value.serialize(serializer),
            Self::Owned(value) => value.serialize(serializer),
            Self::Object(fields) => {
                let mut map = serializer.serialize_map(Some(fields.len()))?;
                for (key, value) in fields {
                    map.serialize_entry(key, value)?;
                }
                map.end()
            }
        }
    }
}

struct RootProjection<'a, 'value>(&'a DocumentView<'value>);

fn serialize_json_root<S: Serializer>(value: &Value, serializer: S) -> Result<S::Ok, S::Error> {
    let Some(fields) = value.as_object() else {
        return value.serialize(serializer);
    };
    let len = fields.len() - usize::from(fields.contains_key("hash"));
    let mut map = serializer.serialize_map(Some(len))?;
    for (key, value) in fields {
        if key != "hash" {
            map.serialize_entry(key, value)?;
        }
    }
    map.end()
}

impl Serialize for RootProjection<'_, '_> {
    fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
        match self.0 {
            DocumentView::Borrowed(value) => serialize_json_root(value, serializer),
            DocumentView::Owned(value) => serialize_json_root(value, serializer),
            DocumentView::Object(fields) => {
                let len = fields.len() - usize::from(fields.contains_key("hash"));
                let mut map = serializer.serialize_map(Some(len))?;
                for (key, value) in fields {
                    if *key != "hash" {
                        map.serialize_entry(key, value)?;
                    }
                }
                map.end()
            }
        }
    }
}

struct DigestWriter<'a>(&'a mut Sha256);
impl Write for DigestWriter<'_> {
    fn write(&mut self, bytes: &[u8]) -> io::Result<usize> {
        self.0.update(bytes);
        Ok(bytes.len())
    }
    fn flush(&mut self) -> io::Result<()> {
        Ok(())
    }
}

/// Hash a complete checked view using the existing root-only metadata convention.
/// Validation precedes projection, and paths follow canonical object/array order.
pub fn tagged_hash_view(tag: &str, view: &DocumentView<'_>) -> Result<String, CanonicalError> {
    if view.contains_float() {
        view.check_no_floats("$")?;
    }
    let mut digest = Sha256::new();
    digest.update(tag.as_bytes());
    digest.update([0]);
    {
        // Batch the compact formatter's small fragments without storing the whole document.
        let mut writer = BufWriter::with_capacity(8192, DigestWriter(&mut digest));
        serde_json::to_writer(&mut writer, &RootProjection(view))
            .map_err(|error| CanonicalError::Serialize(error.to_string()))?;
        writer
            .flush()
            .map_err(|error| CanonicalError::Serialize(error.to_string()))?;
    }
    Ok(finish_digest(digest))
}
