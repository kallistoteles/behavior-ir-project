//! Optional per-thread diagnostic counters; never a source of semantic authority.
use std::cell::{Cell, RefCell};
use std::collections::BTreeSet;

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, serde::Serialize)]
pub struct Work {
    pub document_hash_calls: usize,
    pub document_decode_calls: usize,
    pub document_decode_json_bytes: usize,
    pub record_parse_calls: usize,
    pub record_parse_bytes: usize,
    pub decoded_rows: usize,
    pub unrelated_row_checks: usize,
    pub snapshot_rows: usize,
    pub child_rows: usize,
    pub predicate_evaluations: usize,
    pub query_rows: usize,
    pub provider_rows: usize,
    pub copied_rows: usize,
    pub store_value_rows: usize,
    pub hash_document_json_bytes: usize,
    pub backend_enumerations: usize,
    pub backend_members: usize,
    pub backend_key_candidates: usize,
    pub backend_versions: usize,
    pub backend_record_reads: usize,
    pub backend_commits: usize,
}

thread_local! {
    static WORK: Cell<Work> = Cell::new(Work::default());
    static ALLOWED: RefCell<Option<BTreeSet<(String,String)>>> = const { RefCell::new(None) };
}
/// Independent test expectation for the current operation, never read by semantics.
pub fn allowed_rows(rows: impl IntoIterator<Item = (String, String)>) {
    ALLOWED.with(|a| *a.borrow_mut() = Some(rows.into_iter().collect()));
}
pub fn row(entity: &str, id: &str) {
    let unrelated = ALLOWED.with(|a| {
        a.borrow()
            .as_ref()
            .is_some_and(|s| !s.contains(&(entity.into(), id.into())))
    });
    if unrelated {
        note(|w| w.unrelated_row_checks += 1);
    }
}

pub fn reset() {
    ALLOWED.with(|a| *a.borrow_mut() = None);
    WORK.with(|cell| cell.set(Work::default()));
}
pub fn read() -> Work {
    WORK.with(Cell::get)
}
pub fn note(f: impl FnOnce(&mut Work)) {
    WORK.with(|cell| {
        let mut work = cell.get();
        f(&mut work);
        cell.set(work);
    });
}

// RESIDUAL_PROFILER_SCAFFOLD
pub struct ProfileGuard;
pub fn profile_scope(_: impl Into<String>) -> ProfileGuard { ProfileGuard }
pub fn profile_reset() {}
pub fn profile_read() -> serde_json::Value { serde_json::json!({}) }
pub fn profile_set_byte_counts(_: bool) {}
pub fn profile_count_bytes() -> bool { true }
