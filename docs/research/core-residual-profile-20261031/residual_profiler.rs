#![cfg(feature = "validation-work")]
#![allow(clippy::unwrap_used)]
use behavior_core::{canonical, eval::work};
use serde_json::json;
use sha2::{Digest, Sha256};

#[test]
fn nested_scopes_partition_elapsed_time_and_count_calls() {
    work::profile_reset();
    {
        let _outer = work::profile_scope("outer");
        for _ in 0..2 { let _inner = work::profile_scope("inner"); }
    }
    let rows = work::profile_read();
    assert_eq!(rows["outer"]["calls"],1);
    assert_eq!(rows["inner"]["calls"],2);
    assert_eq!(rows["outer"]["inclusive_ns"].as_u64().unwrap(),
        rows["outer"]["exclusive_ns"].as_u64().unwrap()+rows["inner"]["inclusive_ns"].as_u64().unwrap());
}

#[test]
fn early_error_cleans_up_scope_stack_without_changing_result() {
    fn refusal() -> Result<(), &'static str> {
        let _guard=work::profile_scope("refusal"); Err("same refusal")
    }
    work::profile_reset();
    assert_eq!(refusal(),Err("same refusal"));
    assert_eq!(work::profile_read()["refusal"]["calls"],1);
    work::profile_reset(); assert_eq!(work::profile_read(),json!({}));
}

#[test]
fn profile_read_disables_new_scopes_and_reset_discards_old_totals() {
    work::profile_reset(); { let _g=work::profile_scope("old"); }
    work::profile_reset(); assert_eq!(work::profile_read(),json!({}));
    { let _g=work::profile_scope("disabled"); }
    assert_eq!(work::profile_read(),json!({}));
}

#[test]
fn canonical_hash_scopes_keep_the_actual_hash_and_partition_work() {
    let mut digest=Sha256::new(); digest.update(b"calibration\0{\"a\":1}");
    let expected=format!("sha256:{:x}",digest.finalize());
    work::profile_reset();
    assert_eq!(canonical::tagged_hash("calibration",&json!({"a":1})).unwrap(),expected);
    let rows=work::profile_read();
    for name in ["core::to_canonical_string","core::check_canonical_value","core::serialize_value","core::tagged_hash_canonical_text[calibration]"] {
        assert_eq!(rows[name]["calls"],1,"{name}");
    }
}

#[test]
fn excluded_noncanonical_hash_metadata_still_refuses_before_digest() {
    work::profile_reset();
    assert!(canonical::tagged_hash("calibration",&json!({"hash":1.5,"a":1})).is_err());
    let rows=work::profile_read();
    assert_eq!(rows["core::check_canonical_value"]["calls"],1);
    assert!(rows.get("core::tagged_hash_canonical_text[calibration]").is_none());
}
