#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::json;
use std::{collections::BTreeMap, time::Instant};
use store_api::Backend;

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    assert_eq!(
        args.len(),
        4,
        "N COMMANDS EXPECTED_OR_DASH OUTPUT_DIRECTORY"
    );
    let n: usize = args[0].parse().unwrap();
    let commands: usize = args[1].parse().unwrap();
    let expected = if args[2] == "-" {
        None
    } else {
        Some(std::fs::read(&args[2]).unwrap())
    };
    let out = std::path::Path::new(&args[3]);
    std::fs::create_dir(out).unwrap();
    let case = fixture::Case {
        n,
        commands,
        case_id: format!("population-{n}"),
        ..Default::default()
    };
    let module = fixture::module(&case);
    let mut store = store_api::Store::create(
        store_api::InMemoryBackend::new(),
        &module,
        fixture::genesis(&case, &module),
    )
    .unwrap();
    let start = Instant::now();
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
    let evaluate_ns = start.elapsed().as_nanos();
    assert_eq!(evaluated.record["result"], "ALLOW");
    let bundle = evaluated.bundle.unwrap();
    let start = Instant::now();
    let committed = store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap();
    let commit_ns = start.elapsed().as_nanos();
    assert!(!committed.already);
    assert_eq!(committed.result_state.position, 1);
    let start = Instant::now();
    let text = evaluated.record.to_string();
    let serialization_ns = start.elapsed().as_nanos();
    let decision_path = out.join("decision.json");
    std::fs::write(&decision_path, text.as_bytes()).unwrap();
    if let Some(expected) = &expected {
        assert!(
            text.as_bytes() == expected.as_slice(),
            "decision differs from frozen expected bytes"
        );
    }
    let event = store.backend().record(1).unwrap().unwrap();
    assert_eq!(event.hash().unwrap(), committed.record_id);
    let observation = json!({"event":event,"head":store.backend().head().unwrap(),
        "committed":{"record_id":committed.record_id,"result_state":committed.result_state,
                     "already":committed.already,"evidence_trust":committed.evidence_trust}});
    let event_path = out.join("event.json");
    let bytes = serde_json::to_vec(&observation).unwrap();
    std::fs::write(&event_path, &bytes).unwrap();
    println!(
        "{}",
        json!({"n":n,"commands":commands,"diagnostics":cfg!(feature="validation-work"),
        "evaluate_ns":evaluate_ns,"commit_ns":commit_ns,"serialization_ns":serialization_ns,
        "record_bytes":text.len(),"event_bytes":bytes.len(),"decision_path":decision_path,"event_path":event_path})
    );
}
