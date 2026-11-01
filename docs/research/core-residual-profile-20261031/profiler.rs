// Isolated diagnostic scopes; no semantic result consults these values.
#[derive(Default, serde::Serialize)]
pub struct ProfileRow {
    calls: u64,
    inclusive_ns: u128,
    exclusive_ns: u128,
}
struct ProfileFrame {
    name: String,
    clock: std::time::Instant,
    children: u128,
}
thread_local! {
    static PROFILE_ENABLED: Cell<bool> = const { Cell::new(false) };
    static PROFILE_BYTES: Cell<bool> = const { Cell::new(true) };
    static PROFILE_STACK: RefCell<Vec<ProfileFrame>> = const { RefCell::new(Vec::new()) };
    static PROFILE_TOTALS: RefCell<std::collections::BTreeMap<String,ProfileRow>> = const { RefCell::new(std::collections::BTreeMap::new()) };
}
pub struct ProfileGuard { active: bool }
pub fn profile_scope(name: impl Into<String>) -> ProfileGuard {
    let active=PROFILE_ENABLED.with(Cell::get);
    if active {
        PROFILE_STACK.with(|stack| stack.borrow_mut().push(ProfileFrame {
            name:name.into(), clock:std::time::Instant::now(), children:0,
        }));
    }
    ProfileGuard { active }
}
impl Drop for ProfileGuard {
    #[allow(clippy::expect_used)]
    fn drop(&mut self) {
        if !self.active { return; }
        // Each active guard owns one LIFO frame; calibration checks early exits.
        let frame=PROFILE_STACK.with(|stack| stack.borrow_mut().pop()).expect("unbalanced diagnostic scope");
        let elapsed=frame.clock.elapsed().as_nanos();
        PROFILE_STACK.with(|stack| {
            if let Some(parent)=stack.borrow_mut().last_mut() { parent.children+=elapsed; }
        });
        PROFILE_TOTALS.with(|totals| {
            let mut totals=totals.borrow_mut();
            let row=totals.entry(frame.name).or_default();
            row.calls+=1; row.inclusive_ns+=elapsed;
            row.exclusive_ns+=elapsed.checked_sub(frame.children).expect("child scopes exceed parent");
        });
    }
}
pub fn profile_reset() {
    PROFILE_STACK.with(|stack|assert!(stack.borrow().is_empty()));
    PROFILE_TOTALS.with(|totals|totals.borrow_mut().clear());
    PROFILE_ENABLED.with(|enabled|enabled.set(true));
}
#[allow(clippy::expect_used)]
pub fn profile_read() -> serde_json::Value {
    PROFILE_ENABLED.with(|enabled|enabled.set(false));
    PROFILE_STACK.with(|stack|assert!(stack.borrow().is_empty()));
    // The bounded campaign's nanosecond totals fit the JSON integer domain.
    PROFILE_TOTALS.with(|totals|serde_json::to_value(&*totals.borrow()).expect("bounded diagnostic totals serialize"))
}
pub fn profile_set_byte_counts(enabled: bool) { PROFILE_BYTES.with(|value|value.set(enabled)); }
pub fn profile_count_bytes() -> bool { PROFILE_BYTES.with(Cell::get) }
