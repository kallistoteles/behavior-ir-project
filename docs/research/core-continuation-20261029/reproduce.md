# Reproduce the Core replay materialization comparison

Use a separate behavior-ir-core checkout at exactly
`1a3ae37623cf90b4608a678ef283ee313306d9bb`. The original worktrees are not inputs
to a mutable build. `builds.json` records the lock/source identities and actual
binary hashes from this execution. Timings require CPU 7 and sufficient memory;
changing the environment creates a new measurement series.

1. Copy the retained `replay_materialization.rs` into
   `crates/behavior-core/tests/` and `profile-driver.rs` into
   `crates/behavior-store/examples/replay_materialization_profile.rs`.
2. On the unchanged runtime source, run the red control:

   ```sh
   nix develop -c cargo test --locked --release -p behavior-core --features validation-work --test replay_materialization
   ```

   Only `replay_does_not_reparse_its_already_strictly_decoded_value` should fail.
   `baseline-controls.log` separately records the four unchanged semantic controls
   passing before implementation. The initial `red.log` also contains a mistaken
   expected error prefix in the lexical control; `red-corrected.log` corrects that
   assertion and isolates the intended failure. That first test failure is not
   evidence of a Core defect.

3. Build the uninstrumented baseline:

   ```sh
   nix develop -c env CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo build --locked --release -p behavior-store --example replay_materialization_profile --example execution_evidence_bench
   ```

   Copy the two executables from `target/release/examples/` into a new binary
   directory as `baseline-profile` and `baseline-full-path`.
4. Apply `candidate.patch` with `git apply`. Build the same two examples with the
   same command, copying them as `candidate-profile` and `candidate-full-path`.
   No `validation-work` feature belongs in either timing binary.
5. Run the Core and focused Store commands recorded verbatim in `core-tests.log`
   and `store-tests.log`. The new diagnostic counter test needs
   `--features validation-work`. Core's required production gates remain a
   separate prerequisite to proposing this patch for adoption.
6. Wait for all builds and tests to finish. Run the retained collector with a new
   output directory:

   ```sh
   python3 collect.py /path/to/binary-directory /path/to/new-results
   ```

   The collector pins each child to CPU 7, applies the frozen limits, compares all
   timed decision bytes and all three full-observation pairs, and retains raw
   attempts, metrics, representative lossless outputs and their hashes. It rejects
   missing or duplicate samples and wrong/instrumented driver output. Failed
   attempts and comparisons produce a failure manifest rather than a Complete
   assessment. Compare code and artifacts against `artifact-sha256.json`.

The source patch changes one internal call and its explanatory comment. The
copied example and added tests are research controls. New binaries may differ in
bytes because build paths and compiler conditions matter; this experiment records
the identities actually executed and does not claim independently reproduced
bit-identical builds.
