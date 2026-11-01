#![allow(clippy::unwrap_used)]
//! Research controls against the frozen pre-refactor validators.
use super::*;
use std::cell::Cell;

#[path = "../../tests/support/commands.rs"]
mod model;

include!("typed_materialization_reference.rs");

thread_local! {
    static DECODES07: Cell<usize> = const { Cell::new(0) };
}

pub(super) fn note07_decode() {
    DECODES07.with(|count| count.set(count.get() + 1));
}

fn reference(text: &str) -> Result<crate::commands::CommandIntentBag, RecordError> {
    let raw = crate::canonical::decode_strict(text).map_err(|e| record_error(e.to_string()))?;
    match raw.get("record_version").and_then(Json::as_str) {
        Some(RECORD_VERSION_CURRENT) => reference_validate_record08(&raw),
        Some(RECORD_VERSION_COMMANDS) => reference_validate_record07(&raw),
        _ => Err(record_error("unsupported decision record version")),
    }
}

fn actual(text: &str) -> Result<crate::commands::CommandIntentBag, RecordError> {
    DecisionRecord::from_json(text).map(|record| record.commands)
}

fn compare(raw: &Json, label: &str) {
    let text = raw.to_string();
    assert_eq!(actual(&text), reference(&text), "{label}: {text}");
}

fn archived(raw: &Json) -> Json {
    let mut common = raw.clone();
    let fields = common.as_object_mut().unwrap();
    fields.remove("validation_profile");
    fields.remove("refused_request");
    fields.insert("record_version".into(), json!("0.7"));
    fields.insert("semantic_profile".into(), json!("0.8"));
    fields
        .entry("commands")
        .or_insert_with(|| json!({"declarations":[],"types":[],"intents":[]}));
    for step in common["trace"].as_array_mut().unwrap() {
        if let Some(fields) = step.as_object_mut() {
            for key in ["subject", "obligation", "observations"] {
                fields.remove(key);
            }
        }
    }
    common
}

fn examples() -> Vec<(String, Json)> {
    let corpus: Json =
        serde_json::from_str(include_str!("typed_materialization_corpus.json")).unwrap();
    let mut examples: Vec<_> = corpus
        .as_array()
        .unwrap()
        .iter()
        .map(|row| {
            (
                row["name"].as_str().unwrap().to_owned(),
                row["record"].clone(),
            )
        })
        .collect();
    let mut wire = model::module();
    let emission = wire["actions"][0]["command_effects"][0].clone();
    wire["actions"][0]["command_effects"]
        .as_array_mut()
        .unwrap()
        .push(emission);
    let module = crate::admit(&wire.to_string()).unwrap();
    examples.push((
        "duplicate-commands".into(),
        crate::evaluate(&module, &model::request(2, true).to_string())
            .as_json()
            .clone(),
    ));
    wire["actions"][0]["preconditions"] =
        json!([{"expr":model::boolean(false),"loc":model::loc()}]);
    let denied = crate::admit(&wire.to_string()).unwrap();
    examples.push((
        "denied".into(),
        crate::evaluate(&denied, &model::request(2, true).to_string())
            .as_json()
            .clone(),
    ));
    let error = crate::admit(&model::ratio_module(model::boolean(true)).to_string()).unwrap();
    examples.push((
        "error".into(),
        crate::evaluate(&error, &model::request(0, true).to_string())
            .as_json()
            .clone(),
    ));
    examples.push((
        "invalid-input".into(),
        crate::evaluate(&module, "{").as_json().clone(),
    ));
    let archived: Vec<_> = examples
        .iter()
        .map(|(name, raw)| (format!("archived-{name}"), archived(raw)))
        .collect();
    examples.extend(archived);
    examples
}

fn paths(value: &Json, prefix: &str, output: &mut Vec<String>) {
    output.push(prefix.to_owned());
    match value {
        Json::Object(fields) => {
            for (key, value) in fields {
                let key = key.replace('~', "~0").replace('/', "~1");
                paths(value, &format!("{prefix}/{key}"), output);
            }
        }
        Json::Array(values) => {
            for (index, value) in values.iter().enumerate() {
                paths(value, &format!("{prefix}/{index}"), output);
            }
        }
        _ => {}
    }
}

#[test]
fn current_object_record_reuses_its_common_typed_fields() {
    let examples = examples();
    let raw = &examples[0].1;
    DECODES07.with(|count| count.set(0));
    assert!(actual(&raw.to_string()).is_ok());
    assert_eq!(
        DECODES07.with(Cell::get),
        0,
        "a current object record should not decode the common record again"
    );
}

#[test]
fn all_seed_records_remain_valid_with_exact_command_bags() {
    let examples = examples();
    assert_eq!(examples.len(), 14);
    for (label, raw) in examples {
        assert!(reference(&raw.to_string()).is_ok(), "seed {label}");
        compare(&raw, &label);
    }
}

#[test]
fn public_constructor_matches_frozen_errors_over_field_mutations() {
    let mut tested = 0;
    for (label, raw) in examples() {
        let mut locations = Vec::new();
        paths(&raw, "", &mut locations);
        for location in locations {
            for replacement in [
                Json::Null,
                json!(false),
                json!(0),
                json!(""),
                json!([]),
                json!({}),
            ] {
                if raw.pointer(&location) == Some(&replacement) {
                    continue;
                }
                let mut changed = raw.clone();
                *changed.pointer_mut(&location).unwrap() = replacement;
                compare(&changed, &format!("{label} replace {location}"));
                tested += 1;
            }
            if let Some(fields) = raw.pointer(&location).and_then(Json::as_object) {
                for key in fields.keys() {
                    let mut changed = raw.clone();
                    changed
                        .pointer_mut(&location)
                        .unwrap()
                        .as_object_mut()
                        .unwrap()
                        .remove(key);
                    compare(&changed, &format!("{label} omit {location}/{key}"));
                    tested += 1;
                }
                let mut changed = raw.clone();
                changed
                    .pointer_mut(&location)
                    .unwrap()
                    .as_object_mut()
                    .unwrap()
                    .insert("_unrecognized".into(), json!(true));
                compare(&changed, &format!("{label} unknown {location}"));
                tested += 1;
            }
        }
    }
    assert!(tested > 10000, "corpus did not collect enough actual cases");
    eprintln!("TYPED_MATERIALIZATION_DIFFERENTIAL_CASES={tested}");
}

fn sequence(length: usize) -> Json {
    let mut fields = vec![
        json!("precondition"),
        json!(format!("sha256:{}", "0".repeat(64))),
        json!({}),
        json!(true),
        Json::Null,
        Json::Null,
        json!([]),
        Json::Null,
        Json::Null,
        Json::Null,
        Json::Null,
        Json::Null,
        Json::Null,
    ];
    fields.resize(length, Json::Null);
    json!(fields)
}

#[test]
fn typed_trace_conversion_needs_a_sequence_fallback() {
    let step = sequence(11);
    assert!(serde_json::from_value::<CurrentTrace>(step.clone()).is_ok());
    let error = serde_json::from_value::<SemanticTrace>(step).err().unwrap();
    assert_eq!(
        error.to_string(),
        "invalid length 11, expected fewer elements in array"
    );
    let mut raw = examples()[0].1.clone();
    raw["trace"] = json!([sequence(11)]);
    let expected = reference(&raw.to_string()).unwrap_err();
    assert_eq!(
        expected.message,
        "invalid length 11, expected fewer elements in array"
    );
    compare(&raw, "eleven-element trace counterexample");
}

#[test]
fn sequence_forms_and_compound_errors_keep_their_original_order() {
    let original = examples()[0].1.clone();
    for length in 0..=15 {
        let mut raw = original.clone();
        raw["trace"] = json!([sequence(length)]);
        compare(&raw, &format!("sequence-{length}"));
        let mut invalid = raw.clone();
        invalid["behavior_version"] = json!("not-a-hash");
        compare(&invalid, &format!("sequence-{length}-bad-hash"));
        invalid["validation_profile"] = json!("unknown");
        compare(&invalid, &format!("sequence-{length}-bad-profile"));
    }
    let mut raw = original.clone();
    raw["action"] = json!([original["action"]["name"], original["action"]["hash"]]);
    compare(&raw, "shared action sequence");
    let mut raw = original;
    raw["trace"] = json!([sequence(10)]);
    assert!(reference(&raw.to_string()).is_ok());
    DECODES07.with(|count| count.set(0));
    assert!(actual(&raw.to_string()).is_ok());
    assert_eq!(
        DECODES07.with(Cell::get),
        1,
        "accepted array-form trace must retain its original parser path"
    );
}

fn check_sequences(raw: &Json, label: &str, path: &str, fields: &[(&str, Json)]) -> usize {
    let Some(value) = raw.pointer(path) else {
        return 0;
    };
    if !value.is_object() {
        return 0;
    }
    let sequence: Vec<_> = fields
        .iter()
        .map(|(key, default)| value.get(*key).unwrap_or(default).clone())
        .collect();
    for length in 0..=sequence.len() + 1 {
        let mut values = sequence.clone();
        values.resize(length, Json::Null);
        let mut changed = raw.clone();
        *changed.pointer_mut(path).unwrap() = json!(values);
        compare(&changed, &format!("{label} sequence {path} len {length}"));
    }
    sequence.len() + 2
}

#[test]
fn nested_struct_sequences_preserve_accepted_forms_and_errors() {
    let mut tested = 0;
    for (label, raw) in examples() {
        tested += check_sequences(
            &raw,
            &label,
            "/action",
            &[("name", Json::Null), ("hash", Json::Null)],
        );
        for (i, reason) in raw["reasons"].as_array().unwrap().iter().enumerate() {
            let path = format!("/reasons/{i}");
            tested += check_sequences(
                &raw,
                &label,
                &path,
                &[
                    ("code", Json::Null),
                    ("path", Json::Null),
                    ("details", Json::Null),
                    ("references", json!([])),
                ],
            );
            tested += check_sequences(
                &raw,
                &label,
                &format!("{path}/details"),
                &[
                    ("code", Json::Null),
                    ("node", Json::Null),
                    ("operands", Json::Null),
                ],
            );
            for j in 0..reason["references"].as_array().map_or(0, Vec::len) {
                tested += check_sequences(
                    &raw,
                    &label,
                    &format!("{path}/references/{j}"),
                    &[
                        ("entity", Json::Null),
                        ("id", Json::Null),
                        ("field", Json::Null),
                    ],
                );
            }
            for j in 0..reason["details"]["operands"].as_array().map_or(0, Vec::len) {
                tested += check_sequences(
                    &raw,
                    &label,
                    &format!("{path}/details/operands/{j}"),
                    &[("node", Json::Null), ("value", Json::Null)],
                );
            }
        }
        for (i, step) in raw["trace"].as_array().unwrap().iter().enumerate() {
            let mut fields = vec![
                ("phase", Json::Null),
                ("hash", Json::Null),
                ("reads", Json::Null),
                ("outcome", Json::Null),
                ("param", Json::Null),
                ("role", Json::Null),
                ("rescales", json!([])),
                ("emission", Json::Null),
                ("canonical_index", Json::Null),
                ("field", Json::Null),
            ];
            if raw["record_version"] == "0.8" {
                fields.extend([
                    ("subject", Json::Null),
                    ("obligation", Json::Null),
                    ("observations", Json::Null),
                ]);
            }
            tested += check_sequences(&raw, &label, &format!("/trace/{i}"), &fields);
            for j in 0..step["rescales"].as_array().map_or(0, Vec::len) {
                tested += check_sequences(
                    &raw,
                    &label,
                    &format!("/trace/{i}/rescales/{j}"),
                    &[
                        ("exact", Json::Null),
                        ("rounding", Json::Null),
                        ("scale", Json::Null),
                        ("result", Json::Null),
                    ],
                );
            }
        }
        for i in 0..raw["derived"].as_array().unwrap().len() {
            tested += check_sequences(
                &raw,
                &label,
                &format!("/derived/{i}"),
                &[
                    ("hash", Json::Null),
                    ("phase_state", Json::Null),
                    ("value", Json::Null),
                ],
            );
        }
        for i in 0..raw["changes"].as_array().unwrap().len() {
            tested += check_sequences(
                &raw,
                &label,
                &format!("/changes/{i}"),
                &[
                    ("entity", Json::Null),
                    ("id", Json::Null),
                    ("param", Json::Null),
                    ("field", Json::Null),
                    ("old", Json::Null),
                    ("new", Json::Null),
                ],
            );
        }
        for i in 0..raw["lifecycle"].as_array().map_or(0, Vec::len) {
            tested += check_sequences(
                &raw,
                &label,
                &format!("/lifecycle/{i}"),
                &[
                    ("op", Json::Null),
                    ("entity", Json::Null),
                    ("id", Json::Null),
                    ("value", Json::Null),
                ],
            );
        }
    }
    assert!(tested > 500);
    eprintln!("TYPED_MATERIALIZATION_SEQUENCE_CASES={tested}");
}

#[test]
fn integer_bounds_keep_their_typed_and_semantic_errors() {
    let mut tested = 0;
    for (label, raw) in examples() {
        for i in 0..raw["trace"].as_array().unwrap().len() {
            for number in [
                json!(-1),
                json!(u32::MAX),
                json!(u64::from(u32::MAX) + 1),
                json!(u64::MAX),
            ] {
                let mut changed = raw.clone();
                changed["trace"][i]["canonical_index"] = number;
                compare(&changed, &format!("{label} canonical index bounds"));
                tested += 1;
            }
            let count = raw["trace"][i]["rescales"].as_array().map_or(0, Vec::len);
            for j in 0..count {
                for number in [
                    json!(-1),
                    json!(28),
                    json!(29),
                    json!(255),
                    json!(256),
                    json!(u64::MAX),
                ] {
                    let mut changed = raw.clone();
                    changed["trace"][i]["rescales"][j]["scale"] = number;
                    compare(&changed, &format!("{label} rescale bounds"));
                    tested += 1;
                }
            }
        }
    }
    assert!(tested > 100);
    eprintln!("TYPED_MATERIALIZATION_INTEGER_CASES={tested}");
}

#[test]
fn child_semantic_failure_precedes_sequence_projection_failure() {
    let raw = examples()[0].1.clone();
    let step = raw["trace"]
        .as_array()
        .unwrap()
        .iter()
        .find(|step| {
            step["phase"] == "constraint_post"
                && step["observations"]
                    .as_array()
                    .is_some_and(|v| !v.is_empty())
        })
        .unwrap();
    let mut values: Vec<_> = [
        "phase",
        "hash",
        "reads",
        "outcome",
        "param",
        "role",
        "rescales",
        "emission",
        "canonical_index",
        "field",
        "subject",
        "obligation",
        "observations",
    ]
    .iter()
    .map(|key| {
        if *key == "rescales" {
            step.get(*key).cloned().unwrap_or(json!([]))
        } else {
            step[*key].clone()
        }
    })
    .collect();
    values[12][0]["phase_state"] = json!("S");
    let mut changed = raw;
    changed["trace"] = json!([values]);
    let expected = reference(&changed.to_string()).unwrap_err();
    assert_eq!(expected.message, "invalid child field observation");
    compare(&changed, "v08 semantic failure before array projection");
}
