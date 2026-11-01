# Reproduce archived bundle ownership transfer

Use fresh Core revision `1a3ae37623cf90b4608a678ef283ee313306d9bb`, pinned
Nix/Rust/lockfiles, and a copy of this evidence directory. Preserve earlier
scratch checkouts and study manifests. Build paths can affect binary bytes;
the manifest identifies actual measured executables, without claiming
bit-identical independent rebuilds.

The source-only change is [candidate.patch](candidate.patch), applied on top of
guarded typed-record C. It computes the existing archive hash at the assembly
stage and moves the archive into the event. All validation/hash/backend calls
remain. The diagnostic source-site counters are separate research controls.

## Baseline and controls

1. Copy `../core-typed-record-20261031/projected-record.rs` to Core's
   `crates/behavior-core/src/record.rs`. Copy that study's three
   `typed_materialization_*` support files into `crates/behavior-core/src/record/`,
   and `replay_materialization.rs` into `crates/behavior-core/tests/`.
2. Copy this study's `profile-driver.rs` to
   `crates/behavior-store/examples/replay_materialization_profile.rs`.
   The complete-observation example `execution_evidence_bench` and shared
   fixture/workload helpers already belong to the Core base revision.
3. Install `baseline-counted-store.rs` as Store's `src/store.rs`,
   `counted-work.rs` as Core's `src/eval/work.rs`, and the retained
   `bundle_ownership.rs` / `bundle_hash_order.rs` in Store's `tests/`.
   The diagnostic counters are behind the existing `validation-work` feature.
4. Run the ownership test with that feature before applying the optimization:

```sh
nix develop -c env CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo test --locked --release -p behavior-store --features validation-work --test bundle_ownership
```

The semantic event control passes, and both ownership goals fail with one
event-site clone rather than zero. `red.log` retains that failure. Also run
`--test bundle_hash_order` on the baseline: both exact refusal/precedence tests
must pass. Those controls were added after source review and before the runtime
change. Their baseline result is in `baseline-hash-order.log`.

The initial patch-preparation script used an incorrect broad source-count
assertion and stopped before changing the checkout. A separately started Store
test command consequently still used the baseline. It stopped during compilation:
the normal-only research profile example references phase-profiler APIs when
`validation-work` is enabled, while this experiment installs only work counters.
`baseline-store-tests.log` retains that failure; no tests ran in that command.
Use `--lib --tests` to exclude the normal timing examples from this diagnostic
test invocation. `preflight-notes.json` records both corrections. Neither is a
Core semantic failure. No runtime source was edited while that build was active.

## Normal timing executables

Choose a shared rebuildable target directory and the same build environment for
both arms. This campaign used
`CARGO_TARGET_DIR=/tmp/behavior-ir-core-continuation-20261029/target`,
`CARGO_BUILD_JOBS=3`, `CARGO_INCREMENTAL=0`, under `nix develop`.

On the baseline, build **without validation-work**:

```sh
nix develop -c env CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo build --locked --release -p behavior-store --example replay_materialization_profile --example execution_evidence_bench
```

Save the executables from `target/release/examples/` as `baseline-profile` and
`baseline-full-path` in a separate empty binary directory. This campaign rebuilt
the baseline in the same checkout as the candidate; all baseline timings are
fresh. Baseline build source includes diagnostic hooks, but they are absent in
normal builds. Its snapshot and binary identities remain distinct in the manifest.

Install `moved-counted-store.rs` in place of baseline Store source. The equivalent
runtime-only operation is applying `candidate.patch` to `baseline-store.rs`;
the counted snapshot adds just the archive-site hook. Keep the same counted Work
source and tests. Format the changed files and run the candidate Store checks:

```sh
nix develop -c env CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo test --locked --release -p behavior-store --features validation-work --lib --tests
```

Run the exact targeted Clippy/format commands recorded in `clippy.log` and
`format-check.log`. The full Store command includes the three ownership controls, two
hash-error controls, trusted context/evidence and recovery cases, forged
observations and atomic argument-product failures. It is a Store test gate for
this prototype, not the repository's entire production workspace gate.

Build the same two normal examples and save them as `moved-profile` and
`moved-full-path`. Complete all builds/checks before measurements. Record new
source, lock, compiler, executable and collector hashes if making a new campaign;
do not overwrite the historical precollection file. The exact commands/results
used here are retained in the build and validation logs.

## Collection and verification

Keep exactly those four files in the binary directory. Run
`python3 test_collector.py`: eight controls must pass. They reject missing or
duplicate samples, a missing arm, changed complete bytes and diagnostic timing
mode; they also check nonzero exits, timeout and handled-interrupt output retention.
Explicit observation output paths are recorded without dumping ambient environment.

The collector reads the four earlier `core-residual-profile-20261031/evidence/phase-normal-N.json.gz`
decisions as fixed expected bytes. Keep that sibling evidence available. Choose
a new absent results directory, confirm CPU7 exists, then:

```sh
python3 collect.py /absolute/path/to/four-binaries /absolute/path/to/new-results
```

The matrix is four populations × two arms × seven fresh processes, with alternating
order, plus three full-path cases × two arms: **62 attempts**. Children run
serially, with 8GiB address-space and 180-second limits. Every timed decision
must equal the prior expected bytes. Full observations must match across arms
and pass the fixed coverage/replay checks. Eight decisions and six complete
observations are retained as gzip. Handled failures/timeouts/interrupts preserve
available output/status and cannot produce Complete; power loss/SIGKILL retention
is not promised.

For the retained historical evidence:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 analyze.py
PYTHONDONTWRITEBYTECODE=1 python3 verify.py
python3 - <<'PY'
import hashlib, json
from pathlib import Path
for name, expected in json.loads(Path('artifact-sha256.json').read_text()).items():
    assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected, name
print('Retained file manifest verified.')
PY
```

`analyze.py` deterministically recomputes `analysis.json`; keep new campaigns in
separate copied recipe directories. `verify.py` checks frozen inputs, binaries
and source identities at the historical temporary paths as well as retained
samples/artifacts and all earlier study manifests. If temporary files have been
removed, live-identity checks cannot run; the artifact manifest and retained
source/output data remain available. Its captured successful result is
`artifact-verification.json`.

Compute phase sums within each sample before medians. Report serialization and
process observations alongside commit results, including adverse pairs. Small
full-path cases establish compared behavior, without additional latency claims.
