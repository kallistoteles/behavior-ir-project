# Core investigation: final solution and findings

Completed 2026-11-01; work began 2026-10-31. Source base:
`1a3ae37623cf90b4608a678ef283ee313306d9bb`.

Retain the cumulative **view** candidate. It preserves the existing record,
hashing, validation and error contracts while reducing commit medians by
**25.11–38.37%**, evaluate+commit+first-serialization medians by
**22.06–30.82%**, and measured probe-process medians by **10.48–16.44%** across
the six tested cases. All 42 matched final/original pairs improve for each of
those three metrics. These are descriptive results on this host, not universal
speedup guarantees.

The solution is a reviewable cumulative [patch](solution.patch), validated in
an isolated Core checkout; it has not been merged into a production branch.
This workspace is the preserved project/notes repository. The full candidate
source, fixtures and probe sources are retained in [view-source.tar.gz](view-source.tar.gz),
with [build identities](view-builds.json), [preserved executables](executables.tar.gz)
and [complete reproduction instructions](final-reproduction.md).

## What changes

The patch combines the earlier strict-decode reuse, guarded typed-record field
movement and archived-bundle ownership transfer with two final changes:

- Core validates a complete borrowed document view, omits only a root `hash`
  field, and streams compact ordered JSON through an 8 KiB buffer into SHA-256.
  Hashing no longer needs a deep metadata-removal clone or a whole canonical
  output String. The canonical-string API retains its existing behavior.
- Store constructs private fixed-schema bundle/action-event views. Large
  record/read-fact/context JSON stays borrowed; other fields retain their
  existing `serde_json::to_value` conversion and declaration evaluation order.
  Already-owned v2 candidate content is hashed directly instead of cloning
  that Value through another generic conversion.

Core owns canonical validation/projection/serialization/hash authority. New
Core implementation symbols are public for cross-crate use, but are not
re-exported by the supported engine facade. Store/backend/replay checks remain
independent. Migration events retain their generic path; nested legacy bundles
are serialized without introducing a new semantic bundle check.
[Source inventory and correspondence](hash-source-audit.md),
[independent candidate review](final-candidate-review.md)

The generic `hash_of<T: Serialize>` path deliberately still materializes a Value.
Streaming arbitrary serializers directly can change duplicate-key reduction,
large-integer errors and custom-serialization error precedence. The retained
conversion also preserves NaN-to-null behavior, which direct serde_json writing
shares and which is not independently a reason to reject that path. Likewise,
typed record movement retains the guarded fallback for
sequence-shaped traces, whose accepted field counts differ between the old
current and semantic structures. These are tested compatibility constraints,
not incidental inefficiencies to delete.
[Controls](view-hash-tests.rs),
[earlier array correspondence](../core-typed-record-20261031/report.md)

## Fresh cumulative comparison

Six cumulative arms were rebuilt: original, decode reuse, guarded typed reuse,
bundle move, Core streaming, and borrowed Store views. Seven fresh processes
per arm/case supply 252 native runs; eighteen complete-history comparisons make
270 total. Every native decision and event/head/result matches the original
oracle byte for byte. The three full-observation cases also match older frozen
ordinary, command/reference and history/update observations, including replay.

Times below are medians in milliseconds. Consumer means the within-process sum
of evaluate+commit+first serialization; it excludes fixture creation. Process
includes fixture creation and additional post-window event hashing,
serialization and artifact I/O. These are different workloads.

| Case | Original commit | Final commit | Commit change | Consumer change | Process change |
| --- | ---: | ---: | ---: | ---: | ---: |
| N128 legacy |24.216|16.065|−33.66%|−26.80%|−13.64%|
| N512 legacy |100.891|67.123|−33.47%|−27.72%|−10.48%|
| N2048 legacy |472.567|298.560|−36.82%|−29.44%|−12.77%|
| N8192 legacy |1771.874|1091.920|−38.37%|−30.82%|−13.82%|
| N128, two commands/v2 |96.482|72.162|−25.21%|−22.06%|−15.53%|
| N512, two commands/v2 |432.921|324.225|−25.11%|−22.21%|−16.44%|

The borrowed views add 11.18–22.29% commit reductions versus the streaming arm.
Individual earlier steps are mixed: streaming alone has a+0.07% N512 legacy
commit median and+0.36% N128 legacy process median versus moved; moved has a
small N8192 commit regression versus typed in this campaign. Do not describe
every intermediate step as independently faster or multiply percentages from
the earlier studies. The combined comparison above is measured directly.

First serialization is also mixed. Final/original native Display changes are
−21.49%,−57.21%,−10.36%,−8.39% across the four legacy sizes. N128 legacy has
one adverse pair. **N128 command-v2 regresses 25.67%, all 7 pairs**, from 0.733527
to 0.921789 ms; N512 command-v2 improves 17.33%. Legacy N128 evaluation itself
regresses 1.27%. The complete consumer/process gains remain positive in every
matched pair, but the phase regressions must remain visible.
[All medians and pairs](native-analysis.json),
[complete inventory/byte verification](primary-verification.json)

## Serialization investigation closed at the observed mechanism

The original issue was real. The exact retained historical decode/typed
executables reproduce typed/decode first-Display regressions of 12.01% at N128
and 5.84% at N512 under their retained driver operations. The final candidate's
legacy-shaped driver improves 14.41% and 56.04% versus decode. Historical,
expanded-native and sink probes have different prefixes and compiled contexts;
their samples are kept separate.
[Anchor results](anchors-analysis.json), [probe correspondence](stage-matrices.md)

The first 224-process sink stage separates original O1, repeated originals,
fresh-parsed P1 and parsed repeats. AtN512, typed/decode O1 total regresses
10.35% for Display, 12.19% for to_vec and 14.24% for writer128, versus −0.17% for
a full-capacity writer. This implicates capacity/growth interactions but does
not isolate Display's own capacity or a unique physical cause.

A separately frozen 560-process follow-up crosses matched Display capacities,
full-capacity byte writing and an allocation-free read-only input walk. It
confirms the large typed/decode Display gap narrows or reverses with full
capacity, while the small-v2 final/original regression persists in every sham
sink, all 7 pairs. Full writer preparation at N128 v2 is 0.039106 ms original
versus 0.403400 ms final, while writing is 0.316814 versus 0.323702 ms. The broad
difference is before JSON writing. AtN512 legacy, the old/final difference
also mostly occupies preparation. Preparation includes dispatch, allocation,
capacity inspection and timing; it is not an isolated allocator routine timer.

Touching the input is rejected as a mitigation. Although it often improves
write-only time, **touch+O1 worsens in all 40 arm/case/sink cells**;278/280
matched pairs worsen, with median changes of+11.53–40.61%. Its cost cannot be
hidden by timing only the subsequent write. Repeated and parsed calls have
different allocation/history conditions; they are not proof of cold hardware
or a universal repeated-call improvement.
[Follow-up method](factor-method.md), [results](factors-analysis.json),
[verification](factors-verification.json),
[independent interpretation](serialization-conclusion-audit.md)

The final 105-process PMU diagnostic narrows the preparation mechanism further.
It enables counters around one live `Vec::with_capacity` after actual commit,
disables them before JSON writing, and retains separate empty-window controls.
The release instructions are checked for all four diagnostic executables.
Perf runs onCPU 6 and the workload onCPU 7. Seventy counter runs and 35 separately
sampled runs reproduce both opposite allocation gaps; all 140 stat events report
100% running. No empty-control median is subtracted.

| Allocation window, stat cohort | Wall median | Median instructions (`instructions:u`) |
| --- | ---: | ---: |
| N512 legacy decode |3.313231 ms|8,477,366|
| N512 legacy typed |3.390235 ms|8,466,455|
| N512 legacy final |0.115205 ms|231,992|
| N128 command-v2 original |0.046044 ms|156,080|
| N128 command-v2 final |0.410417 ms|1,613,383|

Instruction-pointer samples identify deferred allocator work. All 118 samples
in the two older N512 cells are in libc allocation paths:117 in
`malloc_consolidate`/`unlink_chunk`, one in `_int_malloc`. Final N128 v2 has
13 such consolidation/unlink samples and one kernel-marked unknown sample.
The exact linked glibc patch chain matches the cited allocator source: a large
allocation can drain previously freed small fastbin chunks, coalesce adjacent
free chunks and unlink their bin entries. Removing earlier temporary trees
can change the work charged to a later allocation. The spans and profiles
support this broad
preparation/history effect; a faster commit can leave a slower first output
allocation in one case.
[Exact allocator source and patch correspondence](allocator-source-conclusion.md)

The bounds matter. The sampling cohort is perturbed and independently reproduces
the gaps; its wall times are not normal-build timings. Final N512 has only one
sample and original N128 v2 has zero, despite positive stat instruction counts.
Thirteen zero-sample report commands exit 0 with retained “data has no samples”
stderr. All 133 samples and their periods are retained:132 user-marked IPs match
the exact mapped ELF function ranges, and one unexpected kernel/unknown IP
remains in the denominator despite the requested `cycles:u` filter. No lost or
throttle records were found. This supports allocator-path attribution, not
exclusive wall-time causation, a cache/TLB/DRAM diagnosis, exact prior chunk
genealogy, or a unique explanation of the smaller historical typed/decode
growing-sink percentage. The similar old decode/typed allocation instruction
counts particularly prevent that last claim.
[PMU method](allocation-pmu-method.md), [results](pmu-analysis.json),
[verification](pmu-verification.json), [independent evidence audit](pmu-evidence-audit.md)

## Validation and provenance

All 13 owner gates passed. Workspace tests:1705 passed,29 ignored; prepared-work
tests 14 passed; incremental-work tests 50 passed,5 ignored; external consumer 139
passed. Formatting, Clippy, build, determinism, boundaries, public surface,
workflows, terminology and shell controls passed. Determinism includes 106
immutable resulting-state archives. Ignored tests remain ignored.
[Gate summary](validation.json), [complete owner log](workspace-gates.log)

Resource-goal red controls ran before their corresponding runtime changes.
Core's canonical-string resource goal failed
at 65,566 bytes before streaming and passes at zero. Known legacy bundle and event
large-JSON rematerialization counts each start at 1; v2 bundle/event counts
start at 2 and 3. All then pass at zero.
Seven Core streaming controls, ten Store view controls including 176 differential
cases, the guarded typed-record comparisons, two serialization-probe controls,
15 primary collector controls, five factor controls and six PMU controls pass.
The source-site counters establish those particular removals; they are not a
global allocator census. Frozen Store comparisons share current Core hashing,
with independent frozen Core hash controls supplying that lower-layer check.

Across the final campaigns, **1,215 measured processes** pass complete-output
checks:550 primary,560 follow-up and 105 PMU. The data retain all pairs, adverse
results and diagnostics, plus six original-reference runs, two intentional
wrong-oracle failures and three separate live PMU calibrations. Every serialized
sink round is checked in Rust after timing; only representative sink outputs
are archived. Primary/factor campaigns retain 210 representative gzip files;
PMU retains every diagnostic output and raw profiles. Exact bytes, not just
lengths or hashes, establish the output comparisons.

The freeze binds sources, executables, aliases, oracles and methods before each
campaign. An independent audit reconstructs all 18 patch files against the base
and verifies source archives and chronology. A stale shared-target preflight
was caught before primary measurement; the candidate was cleaned/rebuilt with
its own target and actual compilation/dep-info checks. Earlier failed gate
attempts concern test-fixture wiring; the initial patch applicability check used
the notes repository and was corrected to a fresh Core base checkout. Diagnostic
format/Clippy setup failures are retained too. No measured child failed.
[Freeze review](freeze-review.md), [gate repairs](gate-repairs.json),
[cache preflight](cache-preflight.json), [patch-check failure](freeze-attempt1.json)

All four prior studies and their 240 manifested files remain unchanged. The
host is shared, CPU 7 pinned,8 GiB virtual-memory limit and 180-second timeout;
frequency and exclusive CPU ownership are not guaranteed. Seven observations
per cell support descriptive medians and paired directions. These fixtures
cover the stated sizes and two-command v2 cases, not all small workloads or
every governance policy's performance.
[Host](host.json), [preservation](prior-preservation.json), [protocol](protocol.md)

## Final disposition

Retain the cumulative patch. For an existing byte-oriented consumer, direct
serde byte writing is a tested optional path: final-candidate full-writer O1
totals improve 28.41–46.74% versus its own Display in the follow-up, all pairs.
Whole-consumer sink gains are smaller/mixed, so this is not another universal
workflow speedup. Exact full capacities come from benchmark oracles. Reproducing
the no-growth result requires an already available capacity bound sufficient
for the output; an undersized hint can still grow. Charge capacity-discovery
or retention costs to the caller's complete workflow. Do not serialize once merely to learn
the size, add a warming traversal, or change a String-returning contract to claim
the byte-sink result. Ordinary to_vec also avoids the Display path without
requiring an exact output-size oracle.

Remaining linear work is classified rather than silently skipped: the complete
record is still produced/retained (4,085,191 decision bytes at N8192), canonical
validation and SHA process its content, and independent backend/governance/
replay checks retain their obligations. Generic serde materialization remains
where it owns semantics. One additional v2 same-owner bundle-hash reuse is
source-justified but unadopted: it requires a new consuming validation factory
and dedicated ownership/retry/error controls. No performance gain is claimed
for it. This is an explicit maintenance/scope choice, not proof of an optimal
implementation.
[Remaining reuse audit](local-reuse-audit.md), [disposition](local-reuse-decision.md)

The implementation's principal maintenance risk is keeping the manual fixed-
schema views and field inventory synchronized with future omitted/default
fields. Keep the differential tests and inventory with schema changes. The
investigation is complete under the current full-record and validation contract;
it recommends a measured compatible solution, preserves its adverse cases, and
bounds the mechanisms it does not establish.
