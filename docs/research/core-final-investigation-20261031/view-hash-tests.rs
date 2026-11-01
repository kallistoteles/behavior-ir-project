#![allow(clippy::unwrap_used, dead_code)]
use super::*;
use crate as store_api;
use crate::{Backend, InMemoryBackend, Store};
use behavior_core as core_api;
use serde_json::{Value, json};
use std::cell::Cell;
#[path = "../../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
#[path = "frozen_hash_reference.rs"]
mod frozen;
use frozen::FrozenHash;

thread_local! { static COPIES: Cell<usize> = const { Cell::new(0) }; }
pub(super) fn note_materialization(tag: &str) {
    if [
        TAG_COMMIT_BUNDLE,
        TAG_COMMIT_BUNDLE_V2,
        TAG_TRANSITION_RECORD,
        TAG_TRANSITION_RECORD_V2,
        behavior_verify::hashing::TAG_CANDIDATE_TRANSITION_V2,
    ]
    .contains(&tag)
    {
        COPIES.with(|n| n.set(n.get() + 1));
    }
}

fn sample(commands: usize) -> (CommitBundle, TransitionRecord) {
    let case = fixture::Case {
        n: 4,
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
    let bundle = store
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
    store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap();
    (bundle, store.backend().record(1).unwrap().unwrap())
}

fn goal(commands: usize, event: bool) {
    let (bundle, record) = sample(commands);
    let expected = if event {
        record.frozen_hash()
    } else {
        bundle.frozen_hash()
    };
    COPIES.with(|n| n.set(0));
    let actual = if event { record.hash() } else { bundle.hash() };
    assert_eq!(actual, expected);
    assert_eq!(
        COPIES.with(Cell::get),
        0,
        "known document hashing must borrow large JSON inputs"
    );
}

#[test]
fn legacy_bundle_does_not_materialize_known_json_again() {
    goal(0, false);
}
#[test]
fn v2_bundle_does_not_materialize_known_json_again() {
    goal(2, false);
}
#[test]
fn legacy_event_does_not_materialize_known_json_again() {
    goal(0, true);
}
#[test]
fn v2_event_does_not_materialize_known_json_again() {
    goal(2, true);
}

#[test]
fn typed_hashes_match_frozen_methods_for_field_mutations_and_omissions() {
    let mutations = vec![
        Value::Null,
        json!(false),
        json!(0),
        json!(u64::MAX),
        json!(0.5),
        json!(""),
        json!("é\n\""),
        json!([]),
        json!({}),
        json!([null]),
        json!({"a":0.5}),
    ];
    let mut compared = 0;
    for commands in [0, 2] {
        let (bundle, event) = sample(commands);
        assert_eq!(bundle.hash(), bundle.frozen_hash());
        assert_eq!(
            serde_json::to_vec(&views::bundle_view(&bundle).unwrap()).unwrap(),
            serde_json::to_vec(&serde_json::to_value(&bundle).unwrap()).unwrap()
        );
        assert_eq!(event.hash(), event.frozen_hash());
        assert_eq!(
            serde_json::to_vec(&views::event_view(&event).unwrap()).unwrap(),
            serde_json::to_vec(&serde_json::to_value(&event).unwrap()).unwrap()
        );
        let base = serde_json::to_value(&bundle).unwrap();
        for key in [
            "format",
            "evaluated_state",
            "behavior_version",
            "store",
            "record",
            "transition_hash",
            "entity_declarations",
            "read_set",
            "write_set",
            "read_facts",
            "write_lifecycle",
            "commit_time",
            "evidence",
            "evaluated_history",
            "authorization_context",
        ] {
            for value in &mutations {
                let mut raw = base.clone();
                raw[key] = value.clone();
                if let Ok(doc) = serde_json::from_value::<CommitBundle>(raw) {
                    assert_eq!(doc.hash(), doc.frozen_hash(), "bundle {key}={value}");
                    compared += 1;
                }
            }
            let mut raw = base.clone();
            raw.as_object_mut().unwrap().remove(key);
            if let Ok(doc) = serde_json::from_value::<CommitBundle>(raw) {
                assert_eq!(doc.hash(), doc.frozen_hash());
                compared += 1;
            }
        }
        let base = serde_json::to_value(&event).unwrap();
        for key in [
            "format",
            "position",
            "previous_record",
            "kind",
            "bundle",
            "migration",
            "bundle_hash",
            "evaluated_against",
            "committed_on",
            "result_state",
            "new_versions",
            "evidence_policy",
            "authorization",
            "created",
            "removed",
            "ref_changes",
        ] {
            for value in &mutations {
                let mut raw = base.clone();
                raw[key] = value.clone();
                if let Ok(doc) = serde_json::from_value::<TransitionRecord>(raw) {
                    assert_eq!(doc.hash(), doc.frozen_hash(), "event {key}={value}");
                    compared += 1;
                }
            }
            let mut raw = base.clone();
            raw.as_object_mut().unwrap().remove(key);
            if let Ok(doc) = serde_json::from_value::<TransitionRecord>(raw) {
                assert_eq!(doc.hash(), doc.frozen_hash());
                compared += 1;
            }
        }
        for number in [i64::MIN, -1, 0, i64::MAX] {
            let mut doc = bundle.clone();
            doc.record = json!({"a":number,"hash":{"metadata":"kept nested"}});
            assert_eq!(doc.hash(), doc.frozen_hash());
            compared += 1;
        }
    }
    assert!(compared > 150);
    eprintln!("typed-document differential cases={compared}");
}

#[test]
fn canonical_error_order_is_over_the_whole_composed_document() {
    let (mut bundle, mut event) = sample(0);
    bundle.record = json!({"a":0.5});
    bundle.read_facts = json!({"z":0.25});
    assert_eq!(
        bundle.hash(),
        Err(StoreError::BundleInvalid(
            "floating-point number in output at $.read_facts.z".into()
        ))
    );
    assert_eq!(bundle.hash(), bundle.frozen_hash());
    event.bundle = Some(bundle);
    event.authorization = Some("ok".into());
    assert_eq!(
        event.hash(),
        Err(StoreError::BundleInvalid(
            "floating-point number in output at $.bundle.read_facts.z".into()
        ))
    );
    assert_eq!(event.hash(), event.frozen_hash());
}

#[test]
fn generic_hash_of_retains_value_conversion_and_map_reduction_semantics() {
    struct Duplicate;
    impl Serialize for Duplicate {
        fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
            use serde::ser::SerializeMap;
            let mut map = serializer.serialize_map(Some(2))?;
            map.serialize_entry("same", &1)?;
            map.serialize_entry("same", &2)?;
            map.end()
        }
    }
    assert_eq!(
        hash_of("generic", &Duplicate),
        hash_of("generic", &json!({"same":2}))
    );
    let error = hash_of("generic", &i128::MAX).unwrap_err();
    assert_eq!(
        error,
        StoreError::BundleInvalid("number out of range".into())
    );
    assert_eq!(
        hash_of("generic", &f64::NAN),
        hash_of("generic", &Value::Null)
    );
}

#[test]
fn nested_legacy_bundle_does_not_gain_new_semantic_validation() {
    let (_, mut event) = sample(0);
    let bundle = event.bundle.as_mut().unwrap();
    bundle.authorization_context = Some(json!({}));
    assert!(bundle.hash().is_err());
    assert!(event.hash().is_ok());
    assert_eq!(event.hash(), event.frozen_hash());
    event.bundle.as_mut().unwrap().record = json!({"float":0.5});
    event.kind = Some("invalid".into());
    assert_eq!(
        event.hash(),
        Err(StoreError::BundleInvalid(
            "event kind/format/history product differs".into()
        ))
    );
    assert_eq!(event.hash(), event.frozen_hash());
}

#[test]
fn some_null_context_is_included_while_none_is_omitted() {
    let (mut bundle, _) = sample(2);
    let absent = bundle.hash().unwrap();
    bundle.authorization_context = Some(Value::Null);
    assert_ne!(bundle.hash().unwrap(), absent);
    assert_eq!(bundle.hash(), bundle.frozen_hash());
}

#[test]
fn generic_serialize_failure_after_a_float_precedes_canonical_validation() {
    struct Failure;
    impl Serialize for Failure {
        fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
            use serde::ser::SerializeMap;
            let mut map = serializer.serialize_map(None)?;
            map.serialize_entry("a", &0.5)?;
            Err(serde::ser::Error::custom("late custom serializer failure"))
        }
    }
    assert_eq!(
        hash_of("generic", &Failure),
        Err(StoreError::BundleInvalid(
            "late custom serializer failure".into()
        ))
    );
}
