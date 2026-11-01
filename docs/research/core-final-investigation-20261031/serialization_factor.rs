#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::{Value as Json, json};
use std::{collections::BTreeMap, fmt::Write as _, time::Instant};

enum Output {
    Text(String),
    Bytes(Vec<u8>),
}
impl Output {
    fn bytes(&self) -> &[u8] {
        match self {
            Self::Text(v) => v.as_bytes(),
            Self::Bytes(v) => v,
        }
    }
    fn capacity(&self) -> usize {
        match self {
            Self::Text(v) => v.capacity(),
            Self::Bytes(v) => v.capacity(),
        }
    }
}

#[derive(Clone, Copy, Default)]
struct Round {
    setup: u128,
    write: u128,
    total: u128,
    before: usize,
    after: usize,
    bytes: usize,
}

fn serialize(value: &Json, mode: &str, length: usize) -> (Output, Round) {
    let start = Instant::now();
    let (output, write_start, before) = match mode {
        "display" => (Output::Text(value.to_string()), start, 0),
        "vec" => (
            Output::Bytes(serde_json::to_vec(value).unwrap()),
            start,
            128,
        ),
        "writer128" | "writer-full" => {
            let capacity = if mode == "writer128" { 128 } else { length };
            let mut bytes = Vec::with_capacity(capacity);
            let before = bytes.capacity();
            let write_start = Instant::now();
            serde_json::to_writer(&mut bytes, value).unwrap();
            (Output::Bytes(bytes), write_start, before)
        }
        "display128" | "display-full" => {
            let capacity = if mode == "display128" { 128 } else { length };
            let mut text = String::with_capacity(capacity);
            let before = text.capacity();
            let write_start = Instant::now();
            write!(&mut text, "{value}").unwrap();
            (Output::Text(text), write_start, before)
        }
        _ => panic!("undeclared sink"),
    };
    let end = Instant::now();
    let round = Round {
        setup: write_start.duration_since(start).as_nanos(),
        write: end.duration_since(write_start).as_nanos(),
        total: end.duration_since(start).as_nanos(),
        before,
        after: output.capacity(),
        bytes: output.bytes().len(),
    };
    (output, round)
}

fn touch(value: &Json, state: &mut u64) {
    fn bytes(value: &[u8], state: &mut u64) {
        for byte in value {
            *state = state.wrapping_mul(16777619) ^ u64::from(*byte);
        }
    }
    match value {
        Json::Null => *state ^= 17,
        Json::Bool(value) => *state ^= u64::from(*value),
        Json::Number(value) => {
            let bits = value.as_u64().unwrap_or_else(|| {
                value
                    .as_i64()
                    .map(|n| n as u64)
                    .unwrap_or_else(|| value.as_f64().unwrap_or(0.0).to_bits())
            });
            *state ^= std::hint::black_box(bits);
        }
        Json::String(value) => bytes(value.as_bytes(), state),
        Json::Array(values) => {
            *state ^= values.len() as u64;
            for value in values {
                touch(value, state);
            }
        }
        Json::Object(values) => {
            *state ^= values.len() as u64;
            for (key, value) in values {
                bytes(key.as_bytes(), state);
                touch(value, state);
            }
        }
    }
}

fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    assert_eq!(args.len(), 6, "N COMMANDS SINK TOUCH EXPECTED OUTPUT");
    let n: usize = args[0].parse().unwrap();
    let commands: usize = args[1].parse().unwrap();
    let mode = &args[2];
    let intervention = &args[3];
    assert!(["sham", "touch"].contains(&intervention.as_str()));
    let expected = std::fs::read(&args[4]).unwrap();
    let mut rounds = [Round::default(); 8];
    let mut first_bytes = None;
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
    let mut checksum = 0;
    if intervention == "touch" {
        touch(&evaluated.record, &mut checksum);
    }
    let checksum = std::hint::black_box(checksum);
    let touch_ns = start.elapsed().as_nanos();
    for (index, slot) in rounds[..4].iter_mut().enumerate() {
        let (output, round) = serialize(&evaluated.record, mode, expected.len());
        if output.bytes() != expected.as_slice() {
            std::fs::write(&args[5], output.bytes()).unwrap();
            panic!("serialization bytes differ from frozen expected record");
        }
        if mode.ends_with("full") {
            assert_eq!(round.before, round.after);
        }
        if index == 0 {
            first_bytes = Some(output.bytes().to_vec());
        }
        *slot = round;
        drop(output);
    }
    let first_bytes = first_bytes.unwrap();
    let start = Instant::now();
    let parsed: Json = serde_json::from_slice(&first_bytes).unwrap();
    let parse_ns = start.elapsed().as_nanos();
    for (index, slot) in rounds[4..].iter_mut().enumerate() {
        let (output, round) = serialize(&parsed, mode, expected.len());
        if output.bytes() != expected.as_slice() {
            std::fs::write(&args[5], output.bytes()).unwrap();
            panic!("serialization bytes differ from frozen expected record");
        }
        if index == 0 {
            assert_eq!(parsed, evaluated.record);
        }
        if mode.ends_with("full") {
            assert_eq!(round.before, round.after);
        }
        *slot = round;
        drop(output);
    }
    std::fs::write(&args[5], &first_bytes).unwrap();
    let rounds: Vec<_> = rounds
        .iter()
        .enumerate()
        .map(|(index, r)| {
            json!({
        "object":if index < 4 {"original"} else {"parsed"}, "ordinal":index % 4 + 1,
        "setup_ns":r.setup,"write_ns":r.write,"total_ns":r.total,"capacity_before":r.before,
        "capacity_after":r.after,"bytes":r.bytes})
        })
        .collect();
    println!(
        "{}",
        json!({"n":n,"commands":commands,"sink":mode,"intervention":intervention,
        "diagnostics":cfg!(feature="validation-work"),"evaluate_ns":evaluate_ns,"commit_ns":commit_ns,
        "touch_ns":touch_ns,"touch_checksum":checksum,"parse_ns":parse_ns,"rounds":rounds,"record_bytes":expected.len()})
    );
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn all_sinks_emit_identical_bytes_and_presized_writers_do_not_grow() {
        let value = json!({"b":[null,true,"é\n\"",u64::MAX],"a":"x".repeat(65536)});
        let expected = value.to_string();
        for mode in [
            "display",
            "vec",
            "writer128",
            "writer-full",
            "display128",
            "display-full",
        ] {
            let (output, r) = serialize(&value, mode, expected.len());
            assert_eq!(output.bytes(), expected.as_bytes());
            assert_eq!(r.setup + r.write, r.total);
            if mode.ends_with("full") {
                assert_eq!(r.before, r.after);
            }
        }
    }
    #[test]
    fn touch_is_read_only_and_depends_on_keys_and_values() {
        let a = json!({"a":[1,"x",null]});
        let before = a.clone();
        let mut first = 0;
        touch(&a, &mut first);
        assert_eq!(a, before);
        let mut second = 0;
        touch(&json!({"b":[1,"x",null]}), &mut second);
        assert_ne!(first, second);
    }
}
