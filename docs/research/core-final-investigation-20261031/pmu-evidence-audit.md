# Independent allocation-window PMU evidence audit

2026-11-01. Read-only audit of the frozen PMU sources, identities, measured
receipts, raw CSV/perf.data, auxiliary outputs and the completed verifier result.
Independent calculations used Python's standard library on CPU6, without
importing or executing the frozen collector/verifier. No tests, builds or new
measurements were run. No existing file, source, binary or freeze was modified.

**The retained 70 stat plus 35 sampling processes reconcile.** Both prescribed
opposite wall gaps reproduce in both cohorts. The data support allocator-path
localization within this diagnostic, with one unexpected kernel-tagged unknown
sample and sparse/zero-sample controls retained explicitly below.
[Frozen method/identities](pmu-precollection.json),
[completed verification](pmu-verification.json)

## Independent integrity and matrix checks

Rehashed all **43 PMU frozen inputs**, four diagnostic executables and four
source archives. Exact archive member inventories and every member hash match
their manifests: view has 350 files; original/decode/typed have 343 each. Shared
view sources match the primary final source manifest, while reference record/
Store identities match their declared original/decode/typed arms. Primary and
factor freeze digests, pinned perf/taskset/libc file identities and the recorded
effective environment match. Controller CPU6, producer CPU7 and the allocation
resource limits agree with the retained launch commands.
[Build/source identities](pmu-builds.json),
[runtime context](pmu/environment.json),
[ELF context](pmu-binary-context.json)

Independently reconstructed the exact ordered matrix, without calling the
collector's matrix function. All **105 measured receipts** are Completed with
exit zero, correct indexed argv/arm/case/mode, post-freeze timestamps and matching
finite nonnegative process durations/stdout fields. All **105 complete output
artifacts** equal their fixed decision oracles; capacities remain unchanged.
All **105 raw CSV/perf.data hashes** match sample receipts. All **140 auxiliary
commands** have the exact expected argv, successful exit and text/receipt
agreement. No failure marker exists. These checks agree with the completed
verifier's reported inventory.
[Measured rows](pmu/samples.jsonl), [attempt receipts](pmu/attempts.jsonl),
[auxiliary receipts](pmu/aux-attempts.jsonl), [assessment](pmu/assessment.json)

Every stat CSV has exactly one finite positive cycles:u and instructions:u
tuple. All **140 event observations report 100.00% running**; stored values
match raw CSV. This is the reported coverage of independent events, not proof
of a hardware scheduling group or exact correspondence with the narrower
Instant interval. Empty windows retain their separate results.

Independently inspected ELF64 relocation/code bytes for the four actual
executables against their frozen annotated windows. The retained call sequence
places the Rust allocation call after Instant::now and before Instant::elapsed,
between the two control calls. Relative GOT destinations and call addresses
match the actual executable bytes. This corroborates the assembly records
without recompiling or executing the producer.
[View assembly](pmu-view-annotated-main.asm),
[decode assembly](pmu-decode-annotated-main.asm),
[typed assembly](pmu-typed-annotated-main.asm),
[original assembly](pmu-original-annotated-main.asm)

## Both directions reproduce

Independent per-cell medians, seven fresh processes per cell:

| Case/arm | Stat allocation wall ms | Stat cycles | Stat instructions | Sampling allocation wall ms |
| --- | ---: | ---: | ---: | ---: |
| N512 c0 decode | 3.313231 | 9,286,001 | 8,477,366 | 4.163549 |
| N512 c0 typed | 3.390235 | 9,565,213 | 8,466,455 | 4.267767 |
| N512 c0 view | 0.115205 | 350,368 | 231,992 | 0.205441 |
| N128 c2 original | 0.046044 | 147,023 | 156,080 | 0.046483 |
| N128 c2 view | 0.410417 | 1,180,440 | 1,613,383 | 0.610791 |

The legacy decode/view ratio is **28.7594× in stat** and **20.2664× in sampling**;
the adverse v2 view/original ratio is **8.91358×** and **13.1401×**, respectively.
Both magnitude and absolute-time thresholds therefore hold in both cohorts.
Every matched repetition has the same direction in each comparison. Sampling
changes the timings materially, so its cohort must remain separate.
[Recorded condition](pmu/record-condition.json),
[retained independent-cohort summaries](pmu-analysis.json)

Empty-window median local wall durations range from 0.000348 to 0.000386 ms
across the five cells. Their instruction medians are 617 and cycle medians
range from 11,240 to 12,681. They assess scaffolding magnitude; no empty-window
median was subtracted. PMU event runtimes can exceed the local allocation wall
interval because control enables a wider region; for example receipt 0 has
13.190255 ms reported event runtime versus 3.313231 ms local wall time. Do not
describe the PMU boundary as instruction-exact or infer a wall-time fraction
from those values.
[Raw receipt 0](pmu/raw-00000.stat.csv), [all local timers](pmu/samples.jsonl)

## Sample denominators, mappings and symbols

Independently reconciled every sample IP and period between raw event dumps
and formatted script output. Nonempty reports' sample counts and approximate
event-period totals match exactly. There are **133 samples**, no unparsed
sample lines, and **13 zero-sample processes**. Those zero-sample perf report
commands exit zero while writing an `Error: ... data has no samples!` diagnostic
to stderr; those messages are preserved and must not be described as absent
auxiliary diagnostics. The raw dumps contain no LOST, THROTTLE or UNTHROTTLE
records, and no corresponding measured/auxiliary loss/throttle warning was
found. Nonempty reports state zero lost samples.
[Script example](pmu/00070.script.txt), [raw example](pmu/00070.raw.txt),
[zero-sample report](pmu/00072.report.txt),
[retained auxiliary stderr](pmu/aux-attempts.jsonl)

| Sampling cell | Samples | Total period weight | Function counts |
| --- | ---: | ---: | --- |
| N512 c0 decode | 58 | 61,028,603 | malloc_consolidate 35; unlink_chunk.isra.0 23 |
| N512 c0 typed | 60 | 64,943,274 | malloc_consolidate 36; unlink_chunk.isra.0 23; _int_malloc 1 |
| N512 c0 view | 1 | 501,504 | _int_malloc 1; six processes have zero samples |
| N128 c2 original | 0 | 0 | All seven processes have zero samples |
| N128 c2 view | 14 | 6,967,634 | malloc_consolidate 8; unlink_chunk.isra.0 5; kernel-tagged unknown 1 |

The **132 user-mode samples** resolve through actual MMAP2 start/offset
information into exact function ranges in the pinned mapped libc. Parsed that
ELF's symbol tables and GNU build-ID directly; all ranges match, with no map or
range misses. All relevant build-ID listings agree with
`67802a55cff437269d8d9608af391b6f583fca73`, whose libc file SHA matches the
freeze. Its malloc/__libc_malloc symbols are the same-address aliases at
0xae8b0; neither receives a retained sample, so no double-counted alias total
is needed here. Taskset initially maps another libc before exec; the actual
sample IPs resolve to the diagnostic's pinned libc, rather than merely to any
libc path appearing somewhere in the raw file.
[Mapped libc identity](pmu-binary-context.json),
[actual mapping and build-ID](pmu/00070.raw.txt),
[build-ID receipt](pmu/00070.buildids.txt)

**One unexpected sample must remain separate.** Index 97, N128 c2 view repetition
3, contains a sample tagged misc 0x1 at `0xffffffffa38015f0`, reported as `[k]`
and `[unknown]`, despite requested cycles:u. Its period is 501,504, about 7.20%
of that cell's total period weight. The remaining 132 samples are tagged misc
0x2. This audit does not establish the anomaly's cause and does not reclassify
it as user allocator work. Preserve it in total denominators and uncertainty.
The frozen analyzer already retains the unknown symbol/DSO entry; it must also
remain explicit in the prose interpretation.
[Unknown sample script](pmu/00097.script.txt),
[raw mode tag](pmu/00097.raw.txt), [report classification](pmu/00097.report.txt)

## Supported interpretation

A defensible statement is: **In the allocation-window diagnostic, both slow
cohorts reproduced their wall gaps, and their sampled user CPU work repeatedly
landed in the pinned libc's malloc_consolidate and unlink_chunk routines.**
The independent stat instruction/cycle differences support additional CPU work
within the wider acknowledged region. This localizes work done when reserving
the output buffer in the tested execution history.

It does not identify which earlier allocation/free sequence created that
state, establish a cache/TLB/DRAM cause, prove those routines account for every
nanosecond of wall time, or transfer the exact ratios to primary binaries.
Sampling lacks callchains; zero samples in a fast cell do not prove a function
was absent, and a single sample is weak evidence of a dominant routine.
Period weights are approximate event weights, not exact wall durations.
Kernel/descheduling effects and the wider control region remain outside an
exclusive user-routine attribution. No new defect requiring campaign rejection
was found; the unknown sample and zero-sample report diagnostics are material
interpretation qualifications.
