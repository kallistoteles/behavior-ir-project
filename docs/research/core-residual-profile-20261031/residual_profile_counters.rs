#![cfg(feature = "validation-work")]
#![allow(clippy::unwrap_used)]
use behavior_core::eval::work;
use behavior_store::documents::{decode,hash_of};
use serde_json::{Value as Json,json};
use sha2::{Digest,Sha256};

fn calibrated(enabled:bool) {
    let value=json!({"a":1});
    let mut digest=Sha256::new(); digest.update(b"residual.calibration\0{\"a\":1}");
    let expected=format!("sha256:{:x}",digest.finalize());
    work::profile_set_byte_counts(enabled); work::reset(); work::profile_reset();
    let root=work::profile_scope("document-calibration");
    assert_eq!(hash_of("residual.calibration",&value).unwrap(),expected);
    assert_eq!(decode::<Json>("calibration",&value).unwrap(),value);
    drop(root);
    let rows=work::profile_read(); let counts=work::read();
    assert_eq!(counts.document_hash_calls,1); assert_eq!(counts.document_decode_calls,1);
    let bytes=if enabled {value.to_string().len()} else {0};
    assert_eq!(counts.hash_document_json_bytes,bytes);
    assert_eq!(counts.document_decode_json_bytes,bytes);
    for label in ["diagnostic::hash_document_bytes","diagnostic::decode_document_bytes","store::hash_to_value"] {
        assert_eq!(rows[label]["calls"],1,"{label}");
    }
    let sum:u64=rows.as_object().unwrap().values().map(|row|row["exclusive_ns"].as_u64().unwrap()).sum();
    assert_eq!(sum,rows["document-calibration"]["inclusive_ns"].as_u64().unwrap());
}

#[test]
fn both_diagnostic_byte_serializations_are_counted_and_named() { calibrated(true); }
#[test]
fn disabling_byte_serializations_preserves_hash_decode_and_call_counts() { calibrated(false); }
