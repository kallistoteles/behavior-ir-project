//! Canonical JSON output: keys sorted by byte value, compact, UTF-8, no floats.
//!
//! This is a serialization concern only; identity is computed separately (see `admit::hash`).

use serde::Serialize;
use serde::de::{Deserialize, Deserializer, MapAccess, SeqAccess, Visitor};
use serde_json::Value;

#[derive(Debug, Clone, PartialEq, Eq, thiserror::Error)]
pub enum CanonicalError {
    #[error("floating-point number in output at {0}")]
    Float(String),
    #[error("serialization failed: {0}")]
    Serialize(String),
}

/// Decode canonical-value JSON before any map reduction can erase duplicates.
/// Insignificant whitespace is allowed; floats (including -0), exponents and
/// integers outside the i64/u64 JSON domains are not canonical values.
pub fn decode_strict(text: &str) -> Result<Value, CanonicalError> {
    serde_json::from_str::<StrictValue>(text)
        .map(|v| v.0)
        .map_err(|e| CanonicalError::Serialize(e.to_string()))
}

/// Decode a typed closed document after strict lexical/value validation.
/// Typed document structs use `deny_unknown_fields`; their checked constructor
/// establishes semantic/hash/key/version constraints separately.
pub fn decode_closed<T: serde::de::DeserializeOwned>(text: &str) -> Result<T, CanonicalError> {
    serde_json::from_value(decode_strict(text)?)
        .map_err(|e| CanonicalError::Serialize(e.to_string()))
}

struct StrictValue(Value);
impl<'de> Deserialize<'de> for StrictValue {
    fn deserialize<D: Deserializer<'de>>(d: D) -> Result<Self, D::Error> {
        d.deserialize_any(StrictVisitor)
    }
}
struct StrictVisitor;
impl<'de> Visitor<'de> for StrictVisitor {
    type Value = StrictValue;
    fn expecting(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("a no-float JSON value with unique object keys")
    }
    fn visit_unit<E: serde::de::Error>(self) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::Null))
    }
    fn visit_bool<E: serde::de::Error>(self, v: bool) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::Bool(v)))
    }
    fn visit_i64<E: serde::de::Error>(self, v: i64) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::Number(v.into())))
    }
    fn visit_u64<E: serde::de::Error>(self, v: u64) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::Number(v.into())))
    }
    fn visit_f64<E: serde::de::Error>(self, _v: f64) -> Result<Self::Value, E> {
        Err(E::custom("noncanonical numeric representation"))
    }
    fn visit_str<E: serde::de::Error>(self, v: &str) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::String(v.into())))
    }
    fn visit_string<E: serde::de::Error>(self, v: String) -> Result<Self::Value, E> {
        Ok(StrictValue(Value::String(v)))
    }
    fn visit_seq<A: SeqAccess<'de>>(self, mut a: A) -> Result<Self::Value, A::Error> {
        let mut values = Vec::new();
        while let Some(v) = a.next_element::<StrictValue>()? {
            values.push(v.0);
        }
        Ok(StrictValue(Value::Array(values)))
    }
    fn visit_map<A: MapAccess<'de>>(self, mut a: A) -> Result<Self::Value, A::Error> {
        let mut values = serde_json::Map::new();
        while let Some(key) = a.next_key::<String>()? {
            if values.contains_key(&key) {
                return Err(serde::de::Error::custom(format!(
                    "duplicate object key `{key}`"
                )));
            }
            let value = a.next_value::<StrictValue>()?;
            values.insert(key, value.0);
        }
        Ok(StrictValue(Value::Object(values)))
    }
}

fn check_no_floats(v: &Value, path: &str) -> Result<(), CanonicalError> {
    match v {
        Value::Number(n) if n.is_f64() => Err(CanonicalError::Float(path.to_string())),
        Value::Array(items) => items
            .iter()
            .enumerate()
            .try_for_each(|(i, c)| check_no_floats(c, &format!("{path}[{i}]"))),
        Value::Object(map) => map
            .iter()
            .try_for_each(|(k, c)| check_no_floats(c, &format!("{path}.{k}"))),
        _ => Ok(()),
    }
}

/// Canonical string of a JSON value. `serde_json`'s map is ordered by key (the
/// `preserve_order` feature is not enabled), which gives byte-order key sorting.
pub fn to_canonical_string(v: &Value) -> Result<String, CanonicalError> {
    check_canonical_value(v)?;
    let text = serde_json::to_string(v).map_err(|e| CanonicalError::Serialize(e.to_string()))?;
    #[cfg(test)]
    hash_stream_tests::note_text(text.len());
    Ok(text)
}

fn check_canonical_value(v: &Value) -> Result<(), CanonicalError> {
    // Allocate diagnostic paths only when there is a float to report.
    if contains_float(v) {
        check_no_floats(v, "$")?;
    }
    Ok(())
}

fn contains_float(value: &Value) -> bool {
    match value {
        Value::Number(number) => number.is_f64(),
        Value::Array(items) => items.iter().any(contains_float),
        Value::Object(items) => items.values().any(contains_float),
        _ => false,
    }
}

/// Canonical string of any serializable value.
pub fn canonical<T: Serialize>(t: &T) -> Result<String, CanonicalError> {
    let v = serde_json::to_value(t).map_err(|e| CanonicalError::Serialize(e.to_string()))?;
    to_canonical_string(&v)
}

/// `SHA-256(UTF8(tag) || 0 || canonical JSON without a top-level hash)`.
/// Nested hash fields remain content. This is the legacy governance algorithm.
/// The complete supplied value must be canonicalizable, including excluded metadata.
pub fn tagged_hash(tag: &str, doc: &Value) -> Result<String, CanonicalError> {
    tagged_hash_view(tag, &DocumentView::Borrowed(doc))
}

/// Internal reuse of bytes already produced by the canonical serializer.
pub(crate) fn tagged_hash_canonical_text(tag: &str, text: &str) -> String {
    use sha2::{Digest, Sha256};
    let mut digest = Sha256::new();
    digest.update(tag.as_bytes());
    digest.update([0]);
    digest.update(text.as_bytes());
    finish_digest(digest)
}

fn finish_digest(digest: sha2::Sha256) -> String {
    use sha2::Digest;
    const HEX: &[u8; 16] = b"0123456789abcdef";
    let mut hash = String::with_capacity(71);
    hash.push_str("sha256:");
    for byte in digest.finalize() {
        hash.push(HEX[usize::from(byte >> 4)] as char);
        hash.push(HEX[usize::from(byte & 15)] as char);
    }
    hash
}

#[cfg(test)]
#[path = "canonical/hash_stream_tests.rs"]
mod hash_stream_tests;

mod view;
pub use view::{DocumentView, tagged_hash_view};
