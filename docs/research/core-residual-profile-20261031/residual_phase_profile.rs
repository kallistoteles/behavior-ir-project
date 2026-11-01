//! Isolated diagnostic probe; no product API.
#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::{Value as Json, json};
use std::{collections::BTreeMap, time::Instant};
#[cfg(feature = "validation-work")]
fn start() {
    core_api::eval::work::profile_reset();
    core_api::eval::work::reset();
}
#[cfg(not(feature = "validation-work"))]
fn start() {}
#[cfg(feature = "validation-work")]
fn stats() -> Json {
    json!({"spans":core_api::eval::work::profile_read(),"work":core_api::eval::work::read()})
}
#[cfg(not(feature = "validation-work"))]
fn stats() -> Json {
    Json::Null
}
fn main() {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let n: usize = args[0].parse().unwrap();
    let reps: usize = args[1].parse().unwrap();
    let variant = &args[2];
    let out = std::path::Path::new(&args[3]);
    #[cfg(feature = "validation-work")]
    core_api::eval::work::profile_set_byte_counts(
        std::env::var("CORE_PROFILE_BYTES").as_deref() != Ok("0"),
    );
    std::fs::create_dir_all(out).unwrap();
    for repetition in 0..reps {
        let mut case = fixture::Case {
            n,
            case_id: format!("population-{n}"),
            ..Default::default()
        };
        if variant == "no-global" || variant == "neither" {
            case.global = "none".into();
        }
        let mut wire = fixture::wire(&case);
        if variant == "no-constraint" || variant == "neither" {
            wire["entities"][0]["constraints"] = json!([]);
        }
        let module = core_api::admit(&wire.to_string()).unwrap();
        let mut store = store_api::Store::create(
            store_api::InMemoryBackend::new(),
            &module,
            fixture::genesis(&case, &module),
        )
        .unwrap();
        start();
        let t = Instant::now();
        #[cfg(feature = "validation-work")]
        let residual_phase = core_api::eval::work::profile_scope("phase::evaluate");
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
        #[cfg(feature = "validation-work")]
        drop(residual_phase);
        let evaluate_ms = t.elapsed().as_secs_f64() * 1000.;
        let evaluate = stats();
        assert_eq!(evaluated.record["result"], "ALLOW");
        let bundle = evaluated.bundle.unwrap();
        start();
        let t = Instant::now();
        #[cfg(feature = "validation-work")]
        let residual_phase = core_api::eval::work::profile_scope("phase::commit");
        let committed = store
            .commit(&module, &bundle.evaluated_state, &bundle)
            .unwrap();
        #[cfg(feature = "validation-work")]
        drop(residual_phase);
        let commit_ms = t.elapsed().as_secs_f64() * 1000.;
        let commit = stats();
        assert!(!committed.already);
        assert_eq!(committed.result_state.position, 1);
        start();
        let t = Instant::now();
        #[cfg(feature = "validation-work")]
        let residual_phase = core_api::eval::work::profile_scope("phase::serialization");
        let record_bytes = evaluated.record.to_string();
        #[cfg(feature = "validation-work")]
        drop(residual_phase);
        let serialize_ms = t.elapsed().as_secs_f64() * 1000.;
        let serialization = stats();
        let path = out.join(format!("{variant}-{n}-{repetition}.record.json"));
        std::fs::write(&path, record_bytes.as_bytes()).unwrap();
        println!(
            "{}",
            json!({"profile_bytes":profile_bytes(),"n":n,"variant":variant,"repetition":repetition,"mode":if cfg!(feature="validation-work"){"instrumented"}else{"uninstrumented"},"record_bytes":record_bytes.len(),"evaluate_ms":evaluate_ms,"commit_ms":commit_ms,"record_serialization_ms":serialize_ms,"evaluate":evaluate,"commit":commit,"serialization":serialization,"record_path":path})
        );
    }
}

#[cfg(feature = "validation-work")]
fn profile_bytes() -> Json {
    json!(core_api::eval::work::profile_count_bytes())
}
#[cfg(not(feature = "validation-work"))]
fn profile_bytes() -> Json {
    Json::Null
}
