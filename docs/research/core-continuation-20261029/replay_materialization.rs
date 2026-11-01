#![allow(clippy::unwrap_used)]
//! Research controls for reuse of a value already decoded inside one replay call.
#[path = "support/commands.rs"]
mod model;

use behavior_core::{DecisionRecord, admit, evaluate, replay};
use serde_json::{Value, json};

fn example() -> (behavior_core::semantic::Module, Value) {
    let module = admit(&model::module().to_string()).unwrap();
    let record = evaluate(&module, &model::request(2, true).to_string());
    assert_eq!(record.as_json()["result"], "ALLOW");
    (module, record.as_json().clone())
}

#[test]
#[cfg(feature = "validation-work")]
fn replay_does_not_reparse_its_already_strictly_decoded_value() {
    let (module, record) = example();
    behavior_core::eval::work::reset();
    assert!(replay(&module, &record.to_string()).matches);
    assert_eq!(
        behavior_core::eval::work::read().record_parse_calls,
        0,
        "replay must retain its ingress strict decode without a second DecisionRecord parse"
    );
}

#[test]
fn same_call_reuse_preserves_closed_validation_and_selected_error() {
    let (module, original) = example();
    let opposite = admit(include_str!("../../../tests/fixtures/wire/valid/invoice.json")).unwrap();
    for mutation in 0..6 {
        let mut bad = original.clone();
        match mutation {
            0 => bad["unexpected"] = json!(true),
            1 => bad["validation_profile"] = json!("unknown"),
            2 => bad["action"]["hash"] = Value::Null,
            3 => { bad["facts"].as_object_mut().unwrap().remove("universe"); }
            4 => bad["commands"]["intents"][0]["payload"]["recipient"] = json!(17),
            _ => bad["result"] = json!("DENY"),
        }
        let text = bad.to_string();
        let error = DecisionRecord::from_json(&text).unwrap_err();
        let outcome = replay(&module, &text);
        assert!(!outcome.matches, "mutation {mutation}");
        assert_eq!(outcome.diff.as_deref(), Some(error.to_string().as_str()));
        assert_eq!(replay(&opposite, &text).diff, outcome.diff);
    }
}

#[test]
fn strict_value_reuse_preserves_accepted_unicode_and_whitespace() {
    let mut wire = model::module();
    wire["actions"][0]["command_effects"][0]["payload"]["recipient"] = model::string("å🚀");
    let module = admit(&wire.to_string()).unwrap();
    let record = evaluate(&module, &model::request(2, true).to_string());
    let escaped = record.to_json_string().replace('å', "\\u00e5").replace('🚀', "\\ud83d\\ude80");
    assert_ne!(escaped, record.to_json_string());
    assert!(replay(&module, &format!(" \n {escaped} \t")).matches);
}

#[test]
fn strict_value_reuse_preserves_module_profile_mismatch() {
    let (_, record) = example();
    let opposite = admit(include_str!("../../../tests/fixtures/wire/valid/invoice.json")).unwrap();
    assert_eq!(replay(&opposite, &record.to_string()).diff.as_deref(),
        Some("INVALID_DECISION_RECORD: record/module profile mismatch"));
}

#[test]
fn same_call_reuse_retains_strict_lexical_ingress() {
    let (module, original) = example();
    let text = original.to_string();
    let mut malformed = vec![
        format!("{{\"record_version\":\"0.8\",{}", &text[1..]),
        format!("{{\"record_vers\\u0069on\":\"0.8\",{}", &text[1..]),
        text[..text.len() - 1].to_owned(),
    ];
    for number in ["1.0", "1e0", "-0", "18446744073709551616"] {
        malformed.push(text.replacen("\"input\":{}", &format!("\"input\":{{\"bad\":{number}}}"), 1));
    }
    malformed.push(text.replacen("\"input\":{}", "\"input\":{\"a\":1,\"a\":2}", 1));
    for bad in malformed {
        assert_ne!(bad, text, "mutation must actually change the input");
        assert!(DecisionRecord::from_json(&bad).is_err());
        let outcome = replay(&module, &bad);
        assert!(!outcome.matches);
        assert!(outcome.diff.unwrap().starts_with("INVALID_DECISION_RECORD: record is not valid JSON:"));
    }
}
