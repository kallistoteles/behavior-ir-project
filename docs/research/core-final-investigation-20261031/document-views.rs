//! Fixed schema views preserve derive field evaluation order and omission predicates.
use super::*;
use behavior_core::canonical::{DocumentView, tagged_hash_view};

fn owned<T: Serialize>(value: &T) -> R<DocumentView<'_>> {
    serde_json::to_value(value)
        .map(DocumentView::Owned)
        .map_err(|error| StoreError::BundleInvalid(error.to_string()))
}

pub(super) fn bundle_view(bundle: &CommitBundle) -> R<DocumentView<'_>> {
    let mut fields = BTreeMap::new();
    macro_rules! field {
        ($name:ident) => {
            fields.insert(stringify!($name), owned(&bundle.$name)?);
        };
    }
    field!(format);
    field!(evaluated_state);
    field!(behavior_version);
    field!(store);
    fields.insert("record", DocumentView::Borrowed(&bundle.record));
    field!(transition_hash);
    field!(entity_declarations);
    field!(read_set);
    field!(write_set);
    if !bundle.read_facts.is_null() {
        fields.insert("read_facts", DocumentView::Borrowed(&bundle.read_facts));
    }
    if !bundle.write_lifecycle.is_empty() {
        field!(write_lifecycle);
    }
    field!(commit_time);
    if bundle.evidence.is_some() {
        field!(evidence);
    }
    if bundle.evaluated_history.is_some() {
        field!(evaluated_history);
    }
    if let Some(context) = &bundle.authorization_context {
        fields.insert("authorization_context", DocumentView::Borrowed(context));
    }
    Ok(DocumentView::Object(fields))
}

pub(super) fn event_view(event: &TransitionRecord) -> R<DocumentView<'_>> {
    let mut fields = BTreeMap::new();
    macro_rules! field {
        ($name:ident) => {
            fields.insert(stringify!($name), owned(&event.$name)?);
        };
    }
    field!(format);
    field!(position);
    field!(previous_record);
    if event.kind.is_some() {
        field!(kind);
    }
    if let Some(bundle) = &event.bundle {
        fields.insert("bundle", bundle_view(bundle)?);
    }
    if event.migration.is_some() {
        field!(migration);
    }
    field!(bundle_hash);
    field!(evaluated_against);
    field!(committed_on);
    field!(result_state);
    field!(new_versions);
    field!(evidence_policy);
    field!(authorization);
    if !event.created.is_empty() {
        field!(created);
    }
    if !event.removed.is_empty() {
        field!(removed);
    }
    if !event.ref_changes.is_empty() {
        field!(ref_changes);
    }
    Ok(DocumentView::Object(fields))
}

fn hash_view(tag: &str, view: &DocumentView<'_>) -> R<String> {
    #[cfg(feature = "validation-work")]
    {
        let bytes = serde_json::to_string(view)
            .map_err(|error| StoreError::BundleInvalid(error.to_string()))?
            .len();
        behavior_core::eval::work::note(|work| {
            work.document_hash_calls += 1;
            work.hash_document_json_bytes += bytes;
        });
    }
    tagged_hash_view(tag, view).map_err(|error| StoreError::BundleInvalid(error.to_string()))
}

pub(super) fn hash_bundle(tag: &str, bundle: &CommitBundle) -> R<String> {
    hash_view(tag, &bundle_view(bundle)?)
}

pub(super) fn hash_event(tag: &str, event: &TransitionRecord) -> R<String> {
    hash_view(tag, &event_view(event)?)
}
