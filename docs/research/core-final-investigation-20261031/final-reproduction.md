# Reproducing the completed investigation

Start with the [primary build, oracle, gate and campaign recipe](reproduce.md).
That file was frozen before primary measurements and is preserved unchanged.
The cumulative patch targets the declared **Core** base, not the project/notes
repository. It applies cleanly in `/tmp/behavior-ir-core-patch-check-20261101`.
Rebuilding at different paths or with a different toolchain can change machine
code and context; it is a new campaign rather than proof of identical timing.

The full executable set is preserved in `executables.tar.gz`, deduplicated by
SHA-256. Its `manifest.json` maps every original executed path/alias to a
`sha256/HASH` member. Verify member hashes before use. The archive includes the
three exact older historical-anchor binaries as well as all current arms.
`executable-preservation.json` records counts and archive identity. Restoring
the original paths preserves argument strings; a different path is a changed
context. Nix interpreter/shared-library paths are external runtime dependencies,
bound by the locked environment and ELF/build-ID evidence.

## Preserved primary campaign

`measurement-precollection.json` binds the primary sources, methods, controls,
builds, 41 executable paths/aliases and 12 live oracles. There are 19 named
current probe executables, three additional older anchor executables, and
aliases; 41 paths do not mean 41 independent builds. All 349 candidate crate
sources/fixtures are in `view-source.tar.gz`. `stream-source.tar.gz` captures
the previous streaming arm; reference source choices are in `build_references.py`
and their earlier immutable snapshots.

Run the three primary collectors sequentially in fresh output directories,
then all three analyses and `verify.py`, as documented in `reproduce.md`.
`primary-verification.json` is the result for the retained 550-process campaign.
Never overwrite the existing freeze or collection directories to rerun.

## Capacity/touch follow-up

Read `factor-method.md` and `factor-review.md`. The source/executables remain
the primary frozen ones. The new ordered matrix and controls are bound by
`factor-precollection.json`. After all other builds/tests/collectors stop:

```sh
python -m unittest -v factor_controls.py
python factor_followup.py freeze
python factor_followup.py collect
python factor_followup.py analyze
python factor_followup.py verify
```

These are instructions for a **new** path-adjusted campaign. The retained
freeze and data already exist and must not be replaced. The completed follow-up
has 560 processes, 4,480 checked Rust rounds and 80 representative outputs.
`factors-verification.json` records its verified status. Preserve touch cost in
`o1_plus_touch_ms` and `first_consumer_ms`; capacity setup is part of total.

## Allocation-window diagnosis

Read `allocation-pmu-method.md`, `allocation-pmu-design.md` and
`pmu-collector-review.md`. This stage uses separate research executables,
without changing the production patch or primary executables. Its four complete
source snapshots are `pmu-{original,decode,typed,view}-source.tar.gz`.
`build_pmu.py` builds the final probe in the isolated candidate target, then
rewrites original/decode/typed sources sequentially in the reference checkout
and target. `pmu-builds.json` binds the exact products. The new example passes
targeted Clippy; the original production source's full owner gates are unchanged.

Inside the locked Nix development shell, build with `build_pmu.py`; capture ELF
symbols, loader context and annotated release instructions with
`capture_pmu_context.py`. The initial formatter/Clippy setup failures are retained
as `pmu-format-attempt1.json` and `pmu-clippy-attempt1.log`; corrected builds do
not overwrite them. All allocation-window calls must be inside the release
clock/control boundary. `pmu-binary-context.json` records the result.

The pinned perf executable is
`/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/bin/perf`.
The earlier capability check uses the locked nixpkgs revision in
`perf-availability.log`. Perf/controller commands use CPU6; taskset moves the
workload to CPU7 before the fixture, with 8 GiB virtual-memory limit and
180-second timeout. The runner kills the whole process group on handled timeout
or interruption. All perf commands set `PERF_CONFIG=/dev/null` and bind selected
allocator/loader/perf environment settings. Do not silently change that context.

In a new campaign with fresh directories:

```sh
python -m unittest -v pmu_controls.py
python allocation_pmu.py calibrate
python allocation_pmu.py freeze
python allocation_pmu.py collect
python allocation_pmu_verify.py
```

Calibration retains two stat windows and one sampled window plus auxiliary
format checks. The measured stage has 70 stat windows; a prespecified condition
permits 35 IP-sampling windows only if both opposite diagnostic gaps reproduce.
They did here. `pmu-verification.json` checks all 105 measured products and
140 auxiliary commands. `pmu-evidence-audit.md` independently checks the raw
samples, period denominators and actual ELF function ranges without executing
the collector/verifier.

Keep the 13 zero-sample report stderr messages and the one kernel-marked unknown
sample. Requested user-only events do not justify erasing unexpected metadata.
The frozen verifier's generic “user IPs” limit describes the requested setting;
the observed exception is explicitly qualified in the final report and audit.
Do not infer zero CPU cost from zero samples or subtract empty-control medians.

## Final integrity and scope

`artifact-sha256.json` covers the completed study's immutable artifacts;
`artifact-verification.json` records its verification. The manifest excludes
itself, the verification receipt and mutable `progress.json`. All four prior
study manifests and their 240 files remain unchanged. Report values come from
the retained cohorts; do not multiply older percentages, merge probe contexts,
discard adverse pairs or label standalone analysis a complete campaign.

The result is a validated compatible patch and bounded investigation, not a
claim of optimal implementation, universal timings or a uniquely identified
cache/DRAM mechanism. Manual view/schema synchronization remains a maintenance
obligation. Additional v2 same-owner reuse is explicitly unadopted, as explained
in `local-reuse-decision.md`.
