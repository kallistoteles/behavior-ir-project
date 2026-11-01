# Reproducing the final Core campaign

The retained patch is cumulative against commit
`1a3ae37623cf90b4608a678ef283ee313306d9bb`. The main checkout contains research
artifacts; the executable candidate lives in
`/tmp/behavior-ir-core-final-20261031`. `solution.patch` contains production
changes and their validation support. The three probe sources are separate
research tools. No runtime merge or publication is implied by the study.

## Candidate and gates

Create a fresh checkout at the base, apply `solution.patch`, and copy
`final_native_probe.rs`, `serialization_factor.rs` and `legacy_anchor_probe.rs`
from this folder to `crates/behavior-store/examples/`. Keep the checkout's
`CARGO_TARGET_DIR` private to that checkout. Use its locked Nix development shell,
the unchanged Cargo lockfile and toolchain, `CARGO_BUILD_JOBS=3` and
`CARGO_INCREMENTAL=0`. Run `scripts/gates.sh`, then the two serialization-probe
controls with `cargo test -p behavior-store --example serialization_factor`.
The normal timing builds must not enable `validation-work`.

`build_final.py CHECKOUT BIN_DIRECTORY TARGET_DIRECTORY` builds the four final
release probes, saves their identities and archives every crate source/fixture.
It expects the retained stream reference executables for a stale-build check.
`view-builds.json`, `view-build.log` and `view-source.tar.gz` are authoritative
for the measured final candidate, rather than earlier staging snapshots.

## Reference arms and original oracles

Use another fresh base checkout and its own target. Run `build_references.py
CHECKOUT NEW_BIN_DIRECTORY TARGET_DIRECTORY` inside the Nix shell with that
target selected. It rewrites record/store sources for original, strict-decode,
guarded typed and moved-bundle arms, compiling sequentially and saving all
three probes per arm. Original/decode/typed source snapshots come from the
earlier typed study; moved Store source comes from the ownership study.
The stream arm is reconstructed by overlaying `stream-source.tar.gz` on a
fresh base checkout, compiling the native/serialization/full examples and
saving them as `stream-native`, `stream-serial` and `stream-full`.

Run `prepare_inputs.py BIN_DIRECTORY NEW_INPUT_DIRECTORY` once before freezing.
It saves six original-arm complete decision/event pairs, checks the four legacy
decisions against older frozen bytes, and retains two intentional wrong-oracle
failures and their actual outputs. The historical anchors use the exact older
saved executables identified in their build manifests. Rebuilt anchors are a
new experiment, not a claim of byte-identical machine code or layout.

Paths in the original collectors and verifier are recorded explicitly. For a
new campaign, choose fresh directories and update those paths before creating a
new manifest; preserve this campaign's evidence unchanged. Build identities
may differ across checkout paths/toolchain environments; compare new source,
contract bytes and all gate outcomes, rather than assuming binary reproducibility.

## Measurement and verification

Stop all builds and tests before measurement. CPU7 must be available and the
host must support an8GiB address-space limit. Run Python with assertions enabled;
the harness refuses optimized Python. `test_collectors.py` must pass.
`freeze.py` constructs equal-length executable aliases, checks patch
applicability to a fresh Core base checkout, then records all existing immutable inputs,
named executables/aliases and expected records in
`measurement-precollection.json`. It refuses to replace an existing freeze.
Review that manifest before running the collectors. Do not overwrite frozen
inputs or binaries between stages.

Using the recorded directories, run sequentially:

```sh
python final_collect.py /tmp/core-final-binaries-20261031 /tmp/core-final-inputs-20261031 native
python serial_collect.py /tmp/core-final-binaries-20261031 /tmp/core-final-inputs-20261031 sinks
python anchor_collect.py /tmp/core-final-anchor-binaries-20261031 /tmp/core-final-inputs-20261031 anchors
python analyze.py native native
python analyze.py sink sinks
python analyze.py anchor anchors
python verify.py
```

These commands assume this study folder is the working directory. Each child
runs on CPU7, with8GiB virtual-memory limit and180-second timeout. A failed or
interrupted stage retains its attempts and cannot be Complete. Collectors refuse
existing output directories. Do not resume by deleting adverse samples; any
replacement campaign requires a new directory and retained prior attempt log.

`stage-matrices.md` defines550 initial measured processes and130 representative
gzip outputs. Verification checks exact matrices/order, attempts, complete bytes,
old manifests, source/binary/oracle provenance and recomputed analyses. Standalone
analysis is descriptive and does not establish completeness. Conditional sink,
touch or PMU stages, if used, require their own precollection manifest, complete
attempt retention and interpretation in the final report. `pmu-method.md`
documents the checked perf capability and the limits of phase counter attribution.
