# Premeasurement collector audit

2026-11-01. Independent read-only review of `final_collect.py`,
`serial_collect.py`, `anchor_collect.py`, `analyze.py`, `verify.py` and
`test_collectors.py`, with their common runner, Rust probes, input preparation
and stage matrix consulted for correspondence. No collectors or runtime files
were edited; no builds, tests or measurements were run. The precollection
manifest was not present during this inspection, so its eventual contents are
an outstanding verification item rather than an approved freeze.

## Findings corrected during review

The original rotation/reversal rule reversed on repetition parity while also
advancing rotation by repetition. With an even arm count this confined each arm
to even or odd positions. For example native original occupied positions
`0,0,4,2,2,4,0`, while decode occupied `1,5,5,1,3,3,1`; the four-arm collectors
had the same parity confinement. The parent changed reversal to depend on case
index, independently of repetition. Reading the revised rule confirms that
successive repetitions now rotate every arm through every position, with one
extra occurrence over seven repetitions. This is counterbalancing, not a
guarantee against temporal drift. Retain the new position-coverage control.
[Revised native order](final_collect.py:19),
[collector controls](test_collectors.py:24)

The runner originally returned and logged different process-clock readings,
and the verifier did not bind sample process timings to attempt receipts.
The revised runner captures elapsed time once after communicate, returns that
value and preserves it in the finally-written attempt; each verifier loop now
requires exact sample/attempt equality. This fixes the concrete provenance gap
for that metric. The wider process measurement stops after child completion
and before controller JSON parsing/receipt writing; the report should use that
actual boundary.
[Revised runner](common.py:43),
[receipt binding](verify.py:76)

## Remaining concrete verification gaps

1. **Stage execution snapshots are not verified.** `verify.py` never reads the
   three stage `environment.json` files. Consequently their captured executed
   binary/input hashes, CPU/resource declarations and counts are not bound to
   precollection. Current live binary SHA checks and argv path checks alone
   cannot establish past executed bytes if an executable was replaced and
   later restored. Add environment-to-freeze checking, including equal-length
   aliases versus named binaries, each required input, and the declared limits.
   Record the precollection digest in each stage environment before any attempt;
   verify the same digest afterward. Keep binaries/source immutable during
   collection; a start snapshot does not detect every possible midrun change.
   [Current source verification](verify.py:35),
   [native snapshot](final_collect.py:68),
   [sink snapshot](serial_collect.py:52),
   [anchor snapshot](anchor_collect.py:24)
2. **Oracle provenance is not recomputed by the final verifier.** It verifies
   live `/tmp` expected-file SHAs from the freeze and sample SHA equality with
   those live files, but does not compare all twelve files with retained
   `reference-inputs/*.gz`, `reference-inputs.json` input/artifact identities,
   the six original generation attempt receipts, or the two intentional
   wrong-oracle failure controls. Input preparation performs the older c0
   decision comparison and actual negative runs, but final verification does
   not independently re-establish those claims. Add an exact oracle inventory:
   six ordered original successes, two declared failures with the intended
   mismatch diagnostics and retained actual bytes, all twelve retained/live
   oracle comparisons, and old frozen c0 decision equality. Freeze all of these
   inputs before measured attempts. This is a verifier gap, not evidence that
   the inspected generated oracles are incorrect.
   [Oracle preparation](prepare_inputs.py:19),
   [negative controls](prepare_inputs.py:32),
   [current oracle use](verify.py:87),
   [retained identities](reference-inputs.json)
3. **Anchor derived sum is not checked.** The collector stores
   `evaluate_commit_ms = evaluate_ms + commit_ms`; the analyzer uses it, but
   `anchor_data` checks only the three-phase consumer sum. A changed
   evaluate_commit_ms can pass the current verifier if its analysis is
   recomputed. Add the missing equality. Require finite nonnegative anchor
   timings and process_ms; sink validation should likewise validate its
   evaluate_ns/commit_ns/parse_ns inputs. Native phase metrics already receive
   integer/nonnegative checks. Rust currently generates these values from
   monotonic timers, but verifier mutation controls should detect corrupted
   receipts rather than rely on the producer.
   [Anchor sum](anchor_collect.py:40),
   [verification omission](verify.py:149),
   [analyzer consumption](analyze.py:87),
   [sink validation](serial_collect.py:31)
4. **No final-verifier mutation tests yet.** The controls exercise inventory,
   schemas, byte equality and runner failures, but do not invoke verifier stage
   functions against synthetic complete receipt/artifact sets. Add small
   synthetic controls for altered process timing, anchor derived sum, omitted
   complete case group, changed execution snapshot, wrong oracle/artifact hash,
   substituted binary alias and mismatched stdout/sample fields. There is no
   need to run real benchmark processes for these tests. The parent reports
   additional controls passing; this audit does not independently execute them.
   [Current controls](test_collectors.py)

Before freezing, ensure precollection includes collectors/common runner,
analyzer/verifier/tests, all Rust probe/fixture sources, stage-matrices.md,
reference and final build manifests, source archives, all executed aliases and
named binaries, all twelve oracle inputs and retained oracles, reference-control
receipts, and identities of the four prior study manifests. `verify_sources`
trusts the freeze's declared inventory; it does not itself require that all
these categories were listed. New hash manifests are integrity records, not
independent proof that a binary was compiled from a source snapshot: retain the
actual normal compilation provenance from the earlier cache correction too.
[Freeze consumer](verify.py:35),
[final build provenance](build_final.py:21)

## What is already sound in the inspected code

The declared matrices agree arithmetically: six cases × six arms × seven
repetitions = 252 native attempts; three full cases × six arms = 18; two
populations × four sinks × four arms × seven = 224 sink attempts; two populations
× four arms × seven = 56 anchors. The total is 550, with 90/32/8 representative
gzip artifacts. Exact final verifier ordering rejects missing, duplicate and
reordered rows, and successful attempt counts include full observations.
[Matrices](stage-matrices.md),
[ordered verification](verify.py:71)

Every native sample compares complete decision **and** event/head/result bytes
with fixed expected bytes; representative outputs are retained by arm/case.
Full cases compare complete observations with older frozen baseline artifacts,
including case/replay structure controls. The serial Rust probe checks all eight
rounds against the frozen expected bytes after timing, and only first-output
bytes are retained by Python; this distinction should remain explicit. Anchors
compare complete decisions while deliberately retaining the older benchmark
prefix. These are stronger than comparing only output lengths or hashes.
[Native/full comparisons](final_collect.py:82),
[all serial round comparisons](serialization_factor.rs:165),
[anchor comparison](anchor_collect.py:36)

Analysis sums measured phases within each process before taking medians,
computes repeat medians within a process, pairs arms by sorted repetition index,
retains every pair's direction and keeps native, sinks and anchors separate.
The ratio of arm medians and matched-pair changes are correctly distinguished.
Sink setup/write/total metrics include preallocation in total; the contrast
does not silently make capacity setup free. No arithmetic defect was found
in these calculations.
[Grouping/pairing](analyze.py:14),
[native sums](final_collect.py:97),
[sink summaries](analyze.py:51)

## Interpretation and operational limits

- Standalone `analyze.py` discovers case groups from available rows. It can
  summarize a partial campaign that has lost an entire complete case group;
  per-group seven-repetition checking does not detect an absent group. Only
  the exact stage inventories in `verify.py` establish campaign completeness.
  Require verification before labeling analysis final, or enforce declared
  inventories in the analyzer as well.
  [Discovered groups](analyze.py:16), [declared check](verify.py:73)
- Seven fresh-process observations per cell support descriptive medians and
  adverse-pair counts, not confidence intervals, a universal speedup or a
  hardware mechanism. Cross-sink pairing by repetition is a matched schedule
  index, not identical machine state. Original repeats precede fresh-parsed
  rounds, with intervening comparisons, output copying, drops and parsing;
  parsed P1 is a fresh object without a promise of cold hardware state.
  [Schedule](serial_collect.py:61), [probe history](serialization_factor.rs:165)
- The native process timer includes post-native-window event retrieval,
  independent event hashing, event serialization and artifact I/O. The sink
  process includes all rounds and parsing. They are different workloads from
  the displayed native phase sums and cannot be substituted for each other.
  [Native post-window work](final_native_probe.rs:64),
  [sink post-window work](serialization_factor.rs:180)
- Handled failure/timeout/interrupt attempts retain stdout/stderr, exit status
  and available raw output. Collection stops and cannot write Complete after
  those paths. There is no atomic durability/fsync guarantee for power loss or
  SIGKILL. The runner kills its direct child, not an arbitrary subprocess tree;
  current probes are expected to be direct local processes.
  [Runner failure retention](common.py:45),
  [collector failure marker](final_collect.py:130)
- Most validation is implemented with Python assert. Run without `-O` and
  without PYTHONOPTIMIZE; an explicit startup guard would make that requirement
  executable. This is a research harness invocation requirement, not a runtime
  application issue.
  [Validators](final_collect.py:40), [verifier assertions](verify.py:35)

The same-owner v2 hash reuse proposal remains a separately justified,
unadopted candidate in [local-reuse-audit.md](local-reuse-audit.md); it is not
part of the six-arm final matrix inspected here.

## Follow-up review after premeasurement fixes

2026-11-01. Re-read the revised collectors, common runner, verifier and controls.
This status supersedes the earlier unresolved findings where explicitly noted.
No collector/runtime edits, builds, test execution or measurements were made
for this follow-up. The parent reports 15 passing controls; that result was not
independently rerun here. The measurement freeze is still absent while owning
gates and the final build finish, so no collected campaign is approved by this
source review.

- **Execution snapshot/freeze binding is implemented.** Every primary collector
  calls `check_precollection()` before creating its campaign output or starting
  a child. It checks declared frozen inputs, binaries, records and the final
  checkout's source snapshot. Each environment records the freeze digest;
  verification binds that digest, snapshot time, declared limits/matrix, binary
  map and oracle map to the freeze. Measured attempt times must follow the
  freeze time, process metrics are finite/nonnegative, and sample process
  metrics equal their receipts. The verifier additionally binds named arm
  binaries to build manifests and anchor aliases to their original historical
  or final legacy binary hashes. This addresses remaining finding 1.
  [Preflight](common.py:35), [environment binding](verify.py:81),
  [binary manifests and anchors](verify.py:48),
  [attempt timing checks](verify.py:73)
- **Oracle provenance checks are implemented.** The verifier requires the
  complete twelve-oracle name set; checks retained gzip size, decompressed
  length/hash, metadata identities and exact live-oracle bytes; verifies six
  ordered successful original generation commands/results; and requires two
  actual Rust failures with exit 101 and their intended mismatch diagnostics.
  It also checks retained actual negative-control outputs against the correct
  original decision and rechecks all four legacy decisions against the older
  frozen outputs. Both final and streaming source archives are compared to
  their source manifests. This addresses remaining finding 2.
  [Oracle verifier](verify.py:102), [source archives](verify.py:45)
- **Anchor timing/sum checks are implemented.** The new anchor validator rejects
  negative and nonfinite native timings, and verification now checks both
  evaluate+commit and consumer sums. Sink validation checks nonnegative integer
  evaluate/commit durations as well as its existing round metrics. `parse_ns`
  remains recorded without a dedicated schema check; current analysis does not
  use it, so this is a bounded residual validation limit rather than a defect
  in any reported calculation. This addresses the material part of finding 3.
  [Anchor validator](anchor_collect.py:22),
  [anchor sums](verify.py:229), [sink validator](serial_collect.py:29)
- **Focused mutation controls were added.** They exercise every arm/sink's
  position coverage, identical returned/logged process duration, invalid anchor
  timings, and changed environment freeze/CPU/binary/input receipts. This
  improves finding 4's coverage. The suite still does not simulate a complete
  550-attempt verifier campaign; its claims should remain focused on the
  actual controls plus verification of real retained data.
  [Order/process controls](test_collectors.py:35),
  [anchor/environment controls](test_collectors.py:88)
- **Optimized Python now fails explicitly.** `common.py` refuses execution when
  assertions are disabled, closing the earlier invocation hazard.
  [Startup guard](common.py:12)

No new substantive matrix, oracle-byte comparison, pairing or inference bug
was found in the revised code. Proceed to freeze only after the actual final
source/build identities and required gates are available. Then run the final
verifier over the full retained data before treating analyzer output as a
complete campaign. The earlier caveats remain: standalone analysis does not
establish matrix completeness; snapshots do not prove immutability throughout
a stage; binary/source binding relies on retained actual build provenance;
and these observations do not identify a CPU/cache/allocator mechanism.
