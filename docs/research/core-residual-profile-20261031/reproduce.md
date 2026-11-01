# Reproduce the residual profile and serialization experiment

Use behavior-ir-core revision `1a3ae37623cf90b4608a678ef283ee313306d9bb`.
This project repository holds evidence; the Core sources live in a separate
checkout. Work in fresh directories and copy these recipes before generating
inventories. Do not overwrite the frozen evidence or either original scratch
checkout. Compiler conditions and paths can change binary bytes: [builds.json](builds.json)
identifies the binaries actually measured, without claiming bit-identical rebuilds.

## Verify the retained evidence

From this study directory, with Python 3 and assertions enabled:

```sh
python3 analyze.py
python3 verify_artifacts.py
python3 - <<'PY'
import hashlib, json
from pathlib import Path
for name, expected in json.loads(Path('artifact-sha256.json').read_text()).items():
    assert hashlib.sha256(Path(name).read_bytes()).hexdigest() == expected, name
print('Retained file manifest verified.')
PY
```

`verify_artifacts.py` also checks live files at the historical `/tmp` paths in
the manifests. If those temporary directories no longer exist, its live-identity
checks cannot run; the self-contained evidence manifest, raw-sample analysis and
archived sources remain available. The retained successful result is
[artifact-verification.json](artifact-verification.json).

## Build the normal A and C serialization probes

Define `study` as a copy of this directory, `prior` as the sibling retained
`core-typed-record-20261031` directory, and `core` as a new isolated Core checkout
at the revision above. Choose empty `bins`, `inputs` and Cargo target directories.
These names are shell variables pointing to absolute paths.

Copy the shared probe into the Core checkout:

```sh
cp "$study/serialization_history_probe.rs" "$core/crates/behavior-store/examples/serialization_history_probe.rs"
cp "$prior/baseline-record.rs" "$core/crates/behavior-core/src/record.rs"
```

From that checkout build **without validation-work**, using its pinned Nix and
Rust configuration. For example, choose a rebuildable cache at `/tmp/core-residual-rebuild-target`:

```sh
nix develop -c env CARGO_TARGET_DIR=/tmp/core-residual-rebuild-target CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo build --locked --release -p behavior-store --example serialization_history_probe
cp /tmp/core-residual-rebuild-target/release/examples/serialization_history_probe "$bins/a-serialize"
```

Replace `record.rs` with `projected-record.rs` from the prior study. For its
libtest-only module, create `crates/behavior-core/src/record/` and copy
`typed_materialization_tests.rs`, `typed_materialization_reference.rs` and
`typed_materialization_corpus.json` there. Copy `replay_materialization.rs` to
`crates/behavior-core/tests/`. Repeat the normal build and save the executable as
`c-serialize`. Run the two schedule tests:

```sh
nix develop -c env CARGO_TARGET_DIR=/tmp/core-residual-rebuild-target CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo test --locked --release -p behavior-store --example serialization_history_probe
```

Both normal serialization binaries must be built and saved **before adding
diagnostic scopes**. This campaign retained the earlier uninstrumented C phase
executable (`projected-profile`) verbatim as `normal-c`. If reconstructing it,
copy the prior `profile-driver.rs` to
`crates/behavior-store/examples/replay_materialization_profile.rs`, build that
example normally against guarded C, and save it as `normal-c`. A fresh rebuild
belongs to a newly identified campaign; it is not the historical binary simply
because the same source was used.

## Reconstruct the scoped source

The shortest source-exact route is to extract [profile-source.tar.gz](profile-source.tar.gz)
over the fresh Core base checkout after building normal binaries. It contains
the 11 scoped files, the shared serialization probe and two new diagnostic test
files. Keep the three libtest support files and replay control copied above.
Check archived file hashes against `builds.json` before building.

To review the generator path instead, start from clean guarded C and:

1. Copy `work-scaffold.rs` over `crates/behavior-core/src/eval/work.rs`.
   It preserves the base counters and adds a no-op profiler API.
2. Copy `residual_profiler.rs` to `crates/behavior-core/tests/`, and
   `residual_profile_counters.rs` to `crates/behavior-store/tests/`.
3. Copy the **prior** `profile-driver.rs` to
   `crates/behavior-store/examples/residual_phase_profile.rs`. The retained file
   named `residual_phase_profile.rs` in this study is already instrumented and
   formatted; do not use it as the generator's uninstrumented input.
4. Run the profiler calibration test before instrumentation; the no-op scaffold
   produces the four intended failures in `profiler-red.log`. An empty schedule
   produced the two failures in `serialization-red.log`; restore the retained
   real probe before building any measured binary.
5. Run `python3 "$study/instrument.py" "$core"`. It asserts source selectors
   before writing any source. It writes the inventory beside the script, hence
   the requirement to use a copied recipe directory. The first historical
   ambiguous selector stopped before any write; the retained generator is fixed.
6. Run rustfmt with edition 2024 and `skip_children=true` on the 11 instrumented
   files, as recorded in `format.log`. Regenerate the inventory's **file hashes**
   after formatting; function insertion counts remain the asserted generator
   results. Compare final files against the retained archive/inventory.

The [patch](instrumentation.patch) shows guarded C and diagnostic changes relative
to the Core base. Root windows and byte-count mode exist only in the diagnostic
driver/build; records do not read scope totals or counters.

Build with the same environment/cache settings and save the executable as `scoped-c`:

```sh
nix develop -c env CARGO_TARGET_DIR=/tmp/core-residual-rebuild-target CARGO_BUILD_JOBS=3 CARGO_INCREMENTAL=0 cargo build --locked --release -p behavior-store --features validation-work --example residual_phase_profile
cp /tmp/core-residual-rebuild-target/release/examples/residual_phase_profile "$bins/scoped-c"
```

Run the exact commands in the first JSON lines of `profiler-core-tests.log`,
`profiler-store-tests.log` and `scoped-frozen-validator-tests.log`, under the same
Nix environment. These yield 26, two and eight passes respectively. The frozen
validator test includes the 21,156 generated comparisons. The schedule tests add
two passes, for 38 Rust tests. These are focused instrumentation controls, not
a rerun of full production workspace gates. Finish formatting and all checks,
then perform a final successful build recheck before freezing identities.

## Prepare inputs, controls and a fresh campaign

Decompress the four retained `evidence/phase-normal-N.json.gz` decisions to
`inputs/N.json` for N128, N512, N2048 and N8192. Their uncompressed hashes and byte
lengths are bound in the manifests. Keep exactly four executables in `bins`:
`normal-c`, `a-serialize`, `c-serialize`, `scoped-c`.

Run `python3 test_collector.py`: eight tests must pass, including error and
handled-interrupt retention. The two historical actual arm probes also ran with
an intentionally wrong expected input and failed; their complete attempts are
in `negative-probe-attempts.jsonl`. A counter-off scoped N128 smoke run verified
exact output and root partitions before the historical freeze. The probe CLI is:

```text
a-serialize N SCHEDULE EXPECTED_RECORD OUTPUT_RECORD
c-serialize N SCHEDULE EXPECTED_RECORD OUTPUT_RECORD
scoped-c N REPETITIONS original OUTPUT_DIRECTORY
normal-c N REPETITIONS original OUTPUT_DIRECTORY
```

The collector sets `CORE_PROFILE_BYTES=1` for full and `0` for count-off; both
modes use the **same scoped executable**. This flag disables only byte-counter
serializations, retaining call/row counters. Keep the existing counter/error
controls when reconstructing that switch.

For a new collection, record new source, executable, lockfile and input hashes
and freeze the protocol/collector identities before running anything measured.
The historical `precollection.json` describes this campaign, not a future rebuild.
Confirm CPU 7 exists; finish all other builds/tests first, then use a new absent
output directory:

```sh
python3 "$study/collect.py" "$bins" "$inputs" /path/to/new-results
```

The script runs children serially, retains every attempt, checks exact inventories
and byte equality, and emits Complete only after all 36 phase and 120 serialization
processes succeed. The 24 gzip outputs retain one complete decision per declared
combination; every process output is compared before temporary raw-file deletion.
Timeouts and handled interrupts retain available output/status and mark collection
failed or interrupted. Abrupt process termination or power loss is outside that
guarantee.

Keep each campaign separate. For analysis, report O1 and P1 independently and use
per-process repeat medians before cohort medians. Never sum nested inclusive times
or subtract diagnostic byte-counter durations to synthesize uninstrumented times.
