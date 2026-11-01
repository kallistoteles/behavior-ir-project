# Core residual costs and serialization context

2026-10-31. The guarded typed-record candidate C still regresses on the **first
post-commit serialization at N512**, by 8.73–11.35% across three schedules.
Repeated serialization of the original Value and serialization of a freshly
parsed Value have better C medians in this campaign. This narrows the regression
to the measured operation history/context; its allocator, cache or compiler
cause remains unknown.

The residual profile shows substantial document materialization, cloning,
canonicalization and digest work, alongside semantic validation and exact
comparison. This continuation adds isolated diagnostics and evidence. It makes
no new runtime optimization or production adoption claim. The prior guarded
candidate and both earlier evidence sets remain unchanged.

## Experiment and preservation

The [frozen protocol](protocol.md) defines two separate experiments:

- 36 phase processes: N128/512/2048/8192 × three repetitions × retained normal C,
  scoped C with byte counters, and the same scoped C with byte counters disabled.
  Mode order rotates by repetition.
- 120 normal serialization processes: N128/N512 × A/C × three schedules × ten
  repetitions. Arm order alternates by repetition. A is the previous strict-decode
  improvement; C adds borrowed typed decoding and guarded common-field movement.

Each child runs alone on CPU 7, with an 8 GiB address-space limit and 180-second
timeout. Builds and checks finished before collection. OS caches were not
flushed. [Environment](evidence/environment.json), [build identities](builds.json),
[all 156 attempts](evidence/attempts.jsonl), [phase samples](evidence/phase-samples.jsonl)
and [serialization samples](evidence/serialization-samples.jsonl) are retained.
All attempts completed successfully. Every emitted decision matched its frozen
expected bytes; N8192 remains **4,085,191 bytes**. The 24 retained gzip decisions
cover every population/mode and population/schedule/arm combination.

[Precollection identities](precollection.json) bind 16 inputs before measurement.
[Verification](artifact-verification.json) checks those inputs, four actual
binaries, four input decisions, 11 scoped source files, original candidate and
lockfiles, both prior study manifests, complete sample inventories, work counts,
all 72 scoped root partitions and all 24 compressed outputs. A fresh-context
background audit independently verified the evidence and recomputed the results.
[analyze.py](analyze.py) reproduces every value in [analysis.json](analysis.json).

## Serialization depends on the measured context

O1 is the first timed `evaluated.record.to_string()` after actual commit. O2–O8
repeat that operation on the original object. P1–P8 use a fresh Value parsed from
O1's identical bytes outside timing. Every String is compared with the expected
bytes after timing and dropped before the next call. Logical equality of the
parsed Value is checked after P1. The schedules are blocked original then parsed,
or O1 followed by alternating calls with either original or parsed leading.

The table reports **100 × (C median / A median − 1)**. Negative means faster C.
For repeats, first take O2–O8 or P2–P8's median within each process, then the
median of ten process summaries. The repeated calls are not independent samples.

| N | Schedule | O1 | Original repeats | P1 | Parsed repeats |
| --- | --- | ---: | ---: | ---: | ---: |
| 128 | blocked | +2.24% | −3.57% | −4.19% | −2.29% |
| 128 | alternating original first | −1.27% | −4.26% | −3.34% | −2.44% |
| 128 | alternating parsed first | −0.45% | −4.80% | −2.42% | −3.07% |
| 512 | blocked | +9.67% | −3.91% | −1.30% | −3.81% |
| 512 | alternating original first | +8.73% | −4.20% | −0.98% | −3.79% |
| 512 | alternating parsed first | +11.35% | −5.41% | −3.41% | −5.03% |

For scale, blocked N512 medians are:

| Arm | O1 ms | Original repeats ms | P1 ms | Parsed repeats ms |
| --- | ---: | ---: | ---: | ---: |
| A | 5.210 | 2.016 | 2.112 | 2.078 |
| C | 5.714 | 1.937 | 2.084 | 1.999 |

N512 O1 is slower for C in **all 30 matched process pairs** across the schedules.
Improved repeat/parsed medians do not mean every individual pair improves;
all adverse observations remain in the raw samples and per-process summaries.
The [prior campaign](../core-typed-record-20261031/report.md) reported +10.69% at
N512 and +8.30% at N128. N512 reproduces here; N128 does not reproduce consistently
across these schedules. The old N128 result remains valid evidence of its own
measured workload.

The expanded probe changes context: it allocates a 16-entry round-results Vec
after commit and before O1, and schedule construction has its own allocation
history before evaluation. The schedules therefore do not promise identical
allocation histories even before O1. Between calls, byte comparisons, first-output
copying, result bookkeeping and String destruction also touch memory. Parsing
creates a fresh representation, without promising cold hardware state. These
controls identify context dependence; they do not isolate allocation behavior,
cache misses, CPU frequency, compiled layout or a specific compiler mechanism.
The source still uses the same Value serializer; no preallocated writer or
alternative serializer was introduced. See [source audit](source-audit.md) and
[probe source](serialization_history_probe.rs).

## Remaining phase work

Elapsed scopes record calls and inclusive/exclusive nanoseconds. Exclusive time
subtracts instrumented children; it still contains uninstrumented work, cleanup
and profiler bookkeeping. The sum of all exclusive scopes equals the root's
inclusive time in every scoped phase. This arithmetic checks coverage of the
recorded nesting, without making broad source scopes into CPU or allocation
profiles.

The following is **one illustrative observation**, counter-off N8192 repetition
1 (zero-based), rather than a sum of independently selected medians. Its commit
root is 1,466.706 ms, evaluation root 464.101 ms, and extra serialization root
38.064 ms. The entire ranking, inclusive times and work counts are retained in
[analysis.json](analysis.json).

| Disjoint commit source-site group | Calls | Exclusive ms | Root share |
| --- | ---: | ---: | ---: |
| Document-to-Value conversion | 5 | 155.621 | 10.61% |
| Document hash wrappers' own residual | 5 | 94.562 | 6.45% |
| Canonical JSON serialization | 8,204 | 84.957 | 5.79% |
| Canonical Value checks | 8,204 | 29.506 | 2.01% |
| Tagged digest and hex helpers | 7 | 111.961 | 7.63% |
| Archive and event bundle clones | 2 | 137.364 | 9.37% |
| Strict JSON decode | 1 | 89.876 | 6.13% |
| Current typed record decode | 1 | 55.417 | 3.78% |
| Common typed-field semantic validation | 1 | 55.395 | 3.78% |
| Current-specific validation residual | 1 | 13.472 | 0.92% |
| Exact reproduced-record comparison | 1 | 82.822 | 5.65% |
| Reproduction record-to-text conversion | 1 | 42.481 | 2.90% |

The first five groups total 476.608 ms (32.50%); including the two bundle clones
gives 613.972 ms (41.86%). These are sums of disjoint source-site exclusive
times. Canonical operations also include child-observation validation, so the
total must not be described as exclusively document hashing. Hash-wrapper own
residual includes cleanup and uninstrumented work; it is not a measurement of
deallocation alone. Digest helpers include setup, updates, finalization and hex
formatting, rather than isolated SHA compression instructions. None of these
totals is a prediction of removable cost.

Other sizeable commit exclusive spans include `commit_impl` (84.138 ms),
`rederive_for` (81.027 ms), `with_current_profile` (69.481 ms), child rules
(61.650 ms), incremental child carrying (55.200 ms), and backend commit
(42.637 ms). Broad wrapper residuals warrant further source inspection before
being assigned to a single mechanism. The two transition-record document hashes
cross existing Store/backend checking boundaries; their repetition alone does
not authorize skipping validation at either boundary.

Evaluation's largest exclusive spans are child rules (89.265 ms), the Store
evaluate residual (88.106 ms), current-profile record construction (78.739 ms),
the returned record clone (71.860 ms), facts-to-JSON (38.398 ms), the transition
digest helper (27.601 ms), and canonical serialization (27.255 ms). Header/final
assembly scopes have small exclusive residuals because substantial work is in
their instrumented children; this does not make record construction cheap.

Both evaluation and commit visit 8,192 child rows and perform three predicate
evaluations. Commit records five document hashes, one backend commit, one backend
record read and two backend versions. It records no document decode calls in
this fixture. Both byte counters are zero in this mode. `record_parse_calls=0`
is a narrow work counter and does not mean no strict ingress decode happened;
that decode is measured by its separate elapsed scope. The serialization phase
has zero work counters and only its root scope, so it provides no internal
serializer partition.

## Byte-count instrumentation materially perturbs the workload

The original diagnostic counters serialize documents to count bytes. Both such
sites are now named separately, including the decode site absent in this fixture.
`CORE_PROFILE_BYTES=0` disables only those extra serializations in the same scoped
binary. Other call/row counts remain active and match across full/off runs.

Commit medians below use three fresh processes per cell, all from this campaign:

| N | Normal C ms | Scoped, full bytes ms | Scoped, bytes off ms | Full byte-counter closures ms |
| --- | ---: | ---: | ---: | ---: |
| 128 | 18.765 | 21.045 | 18.837 | 2.041 |
| 512 | 78.905 | 85.310 | 78.149 | 7.992 |
| 2048 | 373.470 | 402.241 | 330.636 | 35.765 |
| 8192 | 1,413.704 | 1,548.659 | 1,436.314 | 131.613 |

Disabled closures still incur roughly 0.0007–0.0011 ms median bookkeeping.
Counter-off N2048 is faster than normal C, illustrating that instrumentation,
compiler/layout differences and process conditions can perturb more than the
named closure. Subtracting closure medians cannot reconstruct an uninstrumented
run. The normal binary is the exact retained C executable from the preceding
study, measured afresh; these figures are not a new optimization speedup.
Evaluation and serialization medians for every mode are retained in the analysis.

## Validation and next work

Calibration first failed against a no-op profiler (four intended failures), and
schedule tests failed against an empty schedule (two intended failures). The
completed checks comprise **38 passing Rust tests**: 26 profiler/canonical/record
controls, two Store byte-counter tests, eight frozen-validator tests (including
21,156 generated comparisons), and two schedule tests. Eight collector tests
passed, including wrong bytes, incomplete/duplicate schedules, partition errors
and handled-interrupt retention. Both actual normal arm binaries rejected wrong
expected bytes. A scoped counter-off smoke run passed before the measurement
freeze. See [validation](validation.json) and retained logs. The full 656 tests
of the previous candidate study were not rerun as this continuation's gate.

The collector preserves stdout/stderr, exit status and explicit byte-count mode,
including handled timeouts/interruptions, and marks interrupted collection
incomplete. This does not promise retention through SIGKILL or power loss. The
first instrumentation selector was ambiguous; asserted preflight stopped before
writing any files, and the corrected selector targets `evaluate_decoded_request`
specifically. [Preflight notes](preflight-notes.json) preserve that event. A final
successful build recheck after formatting binds the collected scoped binary to
the final inventoried source.

The next optimization investigation should examine operation-local reuse of
already checked materializations and canonical/hash inputs at actual ownership
boundaries, while preserving exact bytes, error precedence and independent
backend checks. A separate first-serialization experiment can vary one context
factor at a time before assigning a cache or allocator explanation. This study
provides priorities and discriminating evidence; it does not establish that
remaining costs are either unavoidable or safely removable.

[Reproduction steps](reproduce.md), [instrumentation patch](instrumentation.patch),
[complete scoped source archive](profile-source.tar.gz) and the
[self-excluding artifact manifest](artifact-sha256.json) preserve the continuation.
