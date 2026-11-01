#![allow(clippy::unwrap_used, dead_code)]
#[cfg(feature = "validation-work")]
compile_error!("allocation PMU probe requires the normal non-instrumented build");
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::json;
use std::collections::BTreeMap;
use std::fs::{File, OpenOptions};
use std::io::{Read, Write};
use std::time::Instant;

fn control(command: &mut File, acknowledgement: &mut File, enabled: bool) {
    command
        .write_all(if enabled { b"enable\n" } else { b"disable\n" })
        .unwrap();
    let mut ack = [0; 5];
    acknowledgement.read_exact(&mut ack).unwrap();
    assert_eq!(&ack, b"ack\n\0");
}

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    assert_eq!(
        args.len(),
        7,
        "N COMMANDS alloc|empty CONTROL ACK EXPECTED OUTPUT"
    );
    let n: usize = args[0].parse().unwrap();
    let commands: usize = args[1].parse().unwrap();
    let mode = args[2].as_str();
    assert!(["alloc", "empty"].contains(&mode));
    let mut command = OpenOptions::new().write(true).open(&args[3]).unwrap();
    let mut acknowledgement = File::open(&args[4]).unwrap();
    let expected = std::fs::read(&args[5]).unwrap();
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
    let committed = store
        .commit(&module, &bundle.evaluated_state, &bundle)
        .unwrap();
    assert!(!committed.already);
    assert_eq!(committed.result_state.position, 1);

    control(&mut command, &mut acknowledgement, true);
    let start = Instant::now();
    let prepared = if mode == "alloc" {
        let bytes: Vec<u8> = Vec::with_capacity(expected.len());
        std::hint::black_box(&bytes);
        Some(bytes)
    } else {
        std::hint::black_box(expected.len());
        None
    };
    let window_ns = start.elapsed().as_nanos();
    control(&mut command, &mut acknowledgement, false);

    // Allocation is outside the enabled empty-control window. Both modes then
    // retain the output buffer through exact serialization/byte validation.
    let mut bytes = prepared.unwrap_or_else(|| Vec::with_capacity(expected.len()));
    let before = bytes.capacity();
    let start = Instant::now();
    serde_json::to_writer(&mut bytes, &evaluated.record).unwrap();
    let write_ns = start.elapsed().as_nanos();
    assert_eq!(before, bytes.capacity());
    std::fs::write(&args[6], &bytes).unwrap();
    assert_eq!(bytes, expected, "complete diagnostic output differs");
    println!(
        "{}",
        json!({"n":n,"commands":commands,"mode":mode,"diagnostics":"allocation-pmu",
        "window_ns":window_ns,"write_ns":write_ns,"record_bytes":bytes.len(),
        "capacity_before":before,"capacity_after":bytes.capacity(),"ack_bytes":5})
    );
}
