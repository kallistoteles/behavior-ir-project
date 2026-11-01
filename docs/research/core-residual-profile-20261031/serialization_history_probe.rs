#![allow(clippy::unwrap_used, dead_code)]
use behavior_core as core_api;
use behavior_store as store_api;
#[path = "../tests/support/execution_evidence_fixtures.rs"]
mod fixture;
use serde_json::{Value as Json, json};
use sha2::{Digest, Sha256};
use std::{collections::BTreeMap, time::Instant};

fn round_schedule(mode: &str) -> Vec<(&'static str, usize)> {
    match mode {
        "blocked" => (1..=8).map(|n|("original",n)).chain((1..=8).map(|n|("parsed",n))).collect(),
        "alternating-original" | "alternating-parsed" => {
            let mut plan=vec![("original",1)];
            for n in 1..=7 {
                let pair=[("original",n+1),("parsed",n)];
                if mode=="alternating-original" { plan.extend(pair); }
                else { plan.extend(pair.into_iter().rev()); }
            }
            plan.push(("parsed",8)); plan
        }
        _ => panic!("unknown declared serialization schedule"),
    }
}

fn main() {
    let args:Vec<_>=std::env::args().skip(1).collect();
    assert_eq!(args.len(),4,"N SCHEDULE EXPECTED_RECORD OUTPUT_RECORD");
    let n:usize=args[0].parse().unwrap(); let order=&args[1];
    let expected=std::fs::read(&args[2]).unwrap();
    let plan=round_schedule(order);
    let case=fixture::Case{n,case_id:format!("population-{n}"),..Default::default()};
    let module=fixture::module(&case);
    let mut store=store_api::Store::create(store_api::InMemoryBackend::new(),&module,fixture::genesis(&case,&module)).unwrap();
    let start=Instant::now();
    let evaluated=store.evaluate(&module,"create",&BTreeMap::new(),&json!({"id0":"new0_0"}),&json!({}),"2026-10-28T00:00:00Z",None).unwrap();
    let evaluate_ms=start.elapsed().as_secs_f64()*1000.;
    assert_eq!(evaluated.record["result"],"ALLOW");
    let bundle=evaluated.bundle.unwrap();
    let start=Instant::now(); let committed=store.commit(&module,&bundle.evaluated_state,&bundle).unwrap();
    let commit_ms=start.elapsed().as_secs_f64()*1000.;
    assert!(!committed.already); assert_eq!(committed.result_state.position,1);
    let mut rounds=Vec::with_capacity(16);
    let mut first_bytes:Option<Vec<u8>>=None;
    let mut parsed:Option<Json>=None; let mut parse_ms=None;
    for (object,ordinal) in plan {
        if object=="parsed" && parsed.is_none() {
            let start=Instant::now();
            parsed=Some(serde_json::from_slice(first_bytes.as_ref().unwrap()).unwrap());
            parse_ms=Some(start.elapsed().as_secs_f64()*1000.);
        }
        let value=if object=="original" {&evaluated.record} else {parsed.as_ref().unwrap()};
        let start=Instant::now(); let text=value.to_string(); let elapsed_ns=start.elapsed().as_nanos();
        // All full comparisons, first-output copying, and destruction occur after the timer.
        assert_eq!(text.as_bytes(),expected.as_slice(),"{object}{ordinal} bytes changed");
        if object=="original" && ordinal==1 { first_bytes=Some(text.as_bytes().to_vec()); }
        if object=="parsed" && ordinal==1 { assert_eq!(parsed.as_ref().unwrap(),&evaluated.record); }
        rounds.push(json!({"object":object,"ordinal":ordinal,"elapsed_ns":elapsed_ns,"bytes":text.len()}));
        drop(text);
    }
    let first=first_bytes.unwrap();
    std::fs::write(&args[3],&first).unwrap();
    println!("{}",json!({"n":n,"order":order,"diagnostics":cfg!(feature="validation-work"),
        "rounds":rounds,"record_bytes":first.len(),"record_sha256":format!("{:x}",Sha256::digest(&first)),
        "evaluate_ms":evaluate_ms,"commit_ms":commit_ms,"parse_ms":parse_ms}));
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn every_schedule_keeps_first_original_and_eight_calls_per_object() {
        for mode in ["blocked","alternating-original","alternating-parsed"] {
            let plan=round_schedule(mode);
            assert_eq!(plan.len(),16);
            assert_eq!(plan.first(),Some(&("original",1)));
            for object in ["original","parsed"] {
                assert_eq!(plan.iter().filter(|(kind,_)|*kind==object).map(|(_,n)|*n).collect::<Vec<_>>(),(1..=8).collect::<Vec<_>>());
            }
        }
    }
    #[test]
    fn order_controls_have_distinct_declared_prefixes() {
        assert_eq!(&round_schedule("blocked")[..3],&[("original",1),("original",2),("original",3)]);
        assert_eq!(&round_schedule("alternating-original")[..3],&[("original",1),("original",2),("parsed",1)]);
        assert_eq!(&round_schedule("alternating-parsed")[..3],&[("original",1),("parsed",1),("original",2)]);
    }
}
