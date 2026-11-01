#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::json;
use std::collections::BTreeMap;
use store_api::{Backend, InMemoryBackend, Store, StoreError};

fn refuse(invalid_time: bool, expected: &str) {
    let case = fixture::Case {
        n: 8,
        ..Default::default()
    };
    let module = fixture::module(&case);
    let mut store = Store::create(
        InMemoryBackend::new(),
        &module,
        fixture::genesis(&case, &module),
    )
    .unwrap();
    let before = store.backend().head().unwrap();
    let mut bundle = store
        .evaluate(
            &module,
            "create",
            &BTreeMap::new(),
            &json!({"id0":"new0_0"}),
            &json!({}),
            "2026-10-28T00:00:00Z",
            None,
        )
        .unwrap()
        .bundle
        .unwrap();
    bundle.authorization_context = Some(json!({}));
    if invalid_time {
        bundle.commit_time = "invalid".into();
    }
    let supplied = serde_json::to_vec(&bundle).unwrap();
    let error = store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap_err();
    assert_eq!(error, StoreError::BundleInvalid(expected.into()));
    assert_eq!(serde_json::to_vec(&bundle).unwrap(), supplied);
    assert_eq!(store.backend().head().unwrap(), before);
    assert!(store.backend().record(1).unwrap().is_none());
    assert!(
        store
            .backend()
            .version_at(
                &store_api::documents::EntityKey {
                    entity: "E".into(),
                    id: "new0_0".into()
                },
                1
            )
            .unwrap()
            .is_none()
    );
}

#[test]
fn archive_hash_still_refuses_legacy_context_before_publication() {
    refuse(false, "legacy bundle contains v2 semantics");
}

#[test]
fn earlier_timestamp_refusal_precedes_archive_hash_refusal() {
    refuse(true, "commit time is not RFC 3339 UTC");
}
