# Reproduce the three arm typed record experiment

Use a fresh behavior-ir-core checkout at
`1a3ae37623cf90b4608a678ef283ee313306d9bb`. Build paths and compiler conditions
can change binary bytes; the manifest identifies the exact binaries actually
executed here, without claiming independent bit-identical rebuilds.

## Baseline A

Apply `prior-decode-reuse.patch`. Copy `profile-driver.rs` to
`crates/behavior-store/examples/replay_materialization_profile.rs`, and copy
`replay_materialization.rs` to `crates/behavior-core/tests/`.

Create `crates/behavior-core/src/record/` and copy these files there:

- `typed_materialization_tests.rs`
- `typed_materialization_reference.rs`
- `typed_materialization_corpus.json`

Apply `test-wiring.patch`. It adds a libtest-only decode counter and includes
the test module. The normal timing build contains neither hook nor module.

Run the baseline control:

```sh
nix develop -c cargo test --locked --release -p behavior-core --lib typed_materialization_tests -- --nocapture
```

The current object-record reuse test should fail with one second typed decode;
the semantic controls should pass. The initial `red.log` used an invalid test
fixture (`body` instead of the required `expr` precondition field).
`red-corrected.log` fixes that fixture before optimization and isolates the
intended failure. The two later integer/child-order controls are supplementary
controls added before C implementation and executed on B and C, as recorded in
their passing logs.

Build timing executables with no validation-work feature:

```sh
nix develop -c env CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo build --locked --release -p behavior-store --example replay_materialization_profile --example execution_evidence_bench
```

Copy the two executables into a separate binary directory as `baseline-profile`
and `baseline-full-path`. This execution reused the exact matching retained
executables from the previous experiment, then measured them afresh.

## Borrowed B and projected C

Apply `borrowed.patch`. Run the semantic controls, excluding C's optimization
goal on this intermediate arm:

```sh
nix develop -c cargo test --locked --release -p behavior-core --lib typed_materialization_tests -- --skip current_object_record_reuses_its_common_typed_fields --nocapture
```

Build with the same normal command and save the executables as `borrowed-profile`
and `borrowed-full-path`.

Apply `projected.patch`, which includes the positional-trace fallback. Run all
eight materialization controls; all must pass. Run the exact full Core and
focused Store commands recorded in `core-tests.log` and `store-tests.log`.
Build and save `projected-profile` and `projected-full-path`.

The complete retained `candidate.patch` describes the tracked record source
relative to the original research revision; it includes the prior decode change
and test wiring. The three source snapshots and incremental patches make the
individual arms reviewable. Preserve the test/oracle/corpus files alongside it.

## Collection

Finish every build, test and lint check before collection. Check CPU 7 exists
and select a new output directory:

```sh
python3 test_collector.py
python3 collect.py /path/to/six-executables /path/to/new-results
```

The declared corpus is 60 timed processes plus nine full-path processes. The
collector preserves all attempts, validates uninstrumented modes, compares every
complete decision and every full-observation triplet, and rejects missing or
duplicate samples. It records actual conditions and produces a failed manifest
if a process or comparison fails. Inspect all samples and derive per-sample sums
before medians; do not substitute sums of phase medians or add percentage gains.

`precollection.json` binds the protocol, source patches, controls and executable
manifest before timing. `artifact-sha256.json` binds the retained investigation.
Full production workspace gates remain separate from these research checks.
