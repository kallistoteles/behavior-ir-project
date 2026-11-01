#![cfg(feature = "validation-work")]
#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::json;
use std::collections::BTreeMap;
use store_api::{Backend, InMemoryBackend, Store};

fn exercise(commands: usize) -> core_api::eval::work::Work {
    let case = fixture::Case {
        n: 8,
        commands,
        ..Default::default()
    };
    let module = fixture::module(&case);
    let mut store = Store::create(
        InMemoryBackend::new(),
        &module,
        fixture::genesis(&case, &module),
    )
    .unwrap();
    let evaluated = store
        .evaluate(
            &module,
            "create",
            &BTreeMap::new(),
            &json!({"id0":"new0_0"}),
            &json!({}),
            "2026-10-28T00:00:00Z",
            None,
        )
        .unwrap();
    assert_eq!(evaluated.record["result"], "ALLOW");
    let bundle = evaluated.bundle.unwrap();
    let supplied_bytes = serde_json::to_vec(&bundle).unwrap();
    let supplied_hash = bundle.hash().unwrap();
    core_api::eval::work::reset();
    let committed = store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap();
    let work = core_api::eval::work::read();
    assert!(!committed.already);
    assert_eq!(work.backend_commits, 1);
    assert_eq!(serde_json::to_vec(&bundle).unwrap(), supplied_bytes);
    let event = store.backend().record(1).unwrap().unwrap();
    assert_eq!(event.hash().unwrap(), committed.record_id);
    assert_eq!(event.bundle_hash, supplied_hash);
    assert_eq!(
        serde_json::to_vec(event.bundle.as_ref().unwrap()).unwrap(),
        supplied_bytes
    );
    assert_eq!(event.bundle.as_ref().unwrap().record, evaluated.record);
    let head = store.backend().head().unwrap().unwrap();
    assert_eq!(head.last_record, committed.record_id);
    assert_eq!(head.state_ref, committed.result_state);
    let recovered = store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap();
    assert!(recovered.already);
    assert_eq!(recovered.record_id, committed.record_id);
    assert_eq!(recovered.result_state, committed.result_state);
    let mut forged = bundle.clone();
    forged.commit_time = "invalid".into();
    // A changed candidate coordinate must be refused before publishing anything.
    forged.transition_hash = format!("sha256:{}", "f".repeat(64));
    assert!(
        store
            .commit(&module, &forged.evaluated_state, &forged)
            .is_err()
    );
    assert_eq!(store.backend().head().unwrap().unwrap(), head);
    assert_eq!(store.backend().record(1).unwrap().unwrap(), event);
    assert!(store.backend().record(2).unwrap().is_none());
    assert_eq!(serde_json::to_vec(&bundle).unwrap(), supplied_bytes);
    work
}

#[test]
fn complete_legacy_and_v2_events_preserve_the_supplied_bundle_and_recover_exactly() {
    exercise(0);
    exercise(2);
}

#[test]
fn legacy_fresh_commit_transfers_its_owned_archive_into_the_event() {
    let work = exercise(0);
    assert_eq!(work.commit_archive_clones, 1);
    assert_eq!(work.commit_event_clones, 0, "owned archive must transfer");
}

#[test]
fn v2_fresh_commit_transfers_its_owned_archive_into_the_event() {
    let work = exercise(2);
    assert_eq!(work.commit_archive_clones, 1);
    assert_eq!(work.commit_event_clones, 0, "owned archive must transfer");
}
