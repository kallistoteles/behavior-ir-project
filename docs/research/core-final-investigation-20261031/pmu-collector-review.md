# Allocation-window PMU collector review

2026-11-01. Read-only review of the new, unfrozen PMU collector, Rust probe,
build script, controls and method. Consulted the installed perf 7.2.7 manuals
as primary sources for output fields and control options. No source edits,
tests, builds or measurements were performed. Analyze/verify companions are
still being authored; their required checks are listed separately below.

The allocation/empty window and complete-byte consumption are well scoped,
but the initial implementation has several concrete prefreeze gaps. The
immutable primary/factor inputs do not need modification to address them.

## Concrete findings

1. **Perf and producer are both pinned to CPU7.** `execute()` applies
   `common.limits` to perf before exec, so its workload inherits the same
   CPU7 affinity. The earlier design explicitly recommends another CPU for
   the controller and retention of both affinities; current environment output
   records only child_cpu. Either place perf on another allowed CPU and pin
   only its workload to CPU7 before fixture setup, or explicitly prespecify and
   disclose this same-CPU synchronization context. A taskset wrapper before
   fixture execution is one option, with its binary/argv/identity frozen. This
   is an intervention/context difference, not evidence of a particular bias.
   [Launch](allocation_pmu.py:23), [inherited limits](common.py:49),
   [design requirement](allocation-pmu-design.md)
2. **The counter parser accepts ambiguous/malformed receipts.** Repeated
   cycles/instructions rows overwrite prior rows in the result dictionary;
   positive infinity also passes the count/runtime `>0` checks. Require
   exactly one finite count/runtime/percentage tuple per expected event and
   reject duplicates. Preserve every unrecognized row and warning rather than
   reporting it as an expected event. Add duplicate/nonfinite controls. The
   existing `<not counted>`, missing-event and running-percentage controls are
   useful. Column positions match the installed perf-stat CSV documentation.
   [Parser](allocation_pmu.py:50), [current controls](pmu_controls.py:11),
   [pinned manual](/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/share/man/man1/perf-stat.1.gz)
3. **The executed binary mapping is not fully established by check_sources.**
   It checks whatever binary paths/arms the build manifest lists, while `one()`
   executes fixed `BINS/execNN` paths. Require exactly the four declared arms
   and their expected executable paths, and bind each source archive's exact
   member inventory/hashes to its source manifest and intended arm. Verify
   view's shared production sources against the final view freeze and the
   three reference arms against their declared original/decode/typed sources.
   Retain actual compile provenance as in the primary campaign. The sequential
   build approach is otherwise reasonable: final uses its own target;
   reference variants rewrite sources sequentially in one reference checkout.
   [Source check](allocation_pmu.py:101), [executed alias](allocation_pmu.py:72),
   [build mapping](build_pmu.py:26)
4. **The PMU freeze omits forthcoming verifier/analyzer sources.** Its explicit
   input list must include those companions and their controls before any
   measured stat process. Also retain/freeze formatting and clippy failed
   attempts alongside successful logs. Bind the exact diagnostic binaries,
   source archives, calibration receipts, executable mappings and prior/factor
   verification identities. Check freeze chronology against each attempt;
   hashing a manifest is insufficient unless its declared inventory is checked.
   [Current freeze list](allocation_pmu.py:117)

## Requirements before physical attribution

The hardcoded libc path/hash establishes a file identity, not which allocator
the diagnostic actually loaded. The current probe/runner records neither
runtime mappings nor allocator-relevant environment. Capture mappings before
fixture setup and emit them after disable, or independently recover and bind
actual mapped DSO paths/build IDs from perf.data before attributing sampled
IPs to routines. Retain `LD_PRELOAD`, `LD_LIBRARY_PATH`, `GLIBC_TUNABLES`,
`MALLOC_*` and relevant perf configuration. Freeze the installed tools used to
decode ELF metadata. Do not infer loaded libc from a primary executable's
RUNPATH or merely from matching glibc version text.
[Current hardcoded DSO binding](allocation_pmu.py:125),
[existing symbolization conditions](allocation-pmu-design.md)

Retain release disassembly for all four actual diagnostic binaries establishing
that allocation and its live black-boxed reference occur between the two wall
clocks, with serialization/destruction outside the enabled region. Source
placement alone is not this evidence. `build_pmu.py` does not currently capture
disassembly. This is a validation requirement before interpreting the window,
not a discovered optimizer transformation.
[Probe window](allocation_pmu_probe.rs:69), [method](allocation-pmu-method.md)

Current auxiliary script output requests only period/IP/symbol/DSO. It does not
explicitly export lost/throttle metadata. Preserve a raw event dump or suitable
explicit metadata output in addition to the normal sample report; the pinned
perf-script manual provides `--show-lost-events`. Account for zero samples,
lost/throttled records, unknown/unsymbolized DSOs and parsing failures. A zero-
sample report must remain a valid reported observation, not be manufactured
into zero allocator cost or silently dropped. Bind actual sample periods as
well as counts; `-F 997` is a requested frequency, not a fixed period or a
promise of 997 samples per wall second in these short windows.
[Auxiliary commands](allocation_pmu.py:171),
[pinned script manual](/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/share/man/man1/perf-script.1.gz),
[pinned record manual](/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/share/man/man1/perf-record.1.gz)

The stat command requests two independent events without a hardware group.
Requiring at least 99% reported running is a useful coverage check, but do not
describe this as an enforced simultaneous group or compute strict same-interval
ratios without additional justification. Perf's normal scaled counts should
be labeled accordingly unless `--no-scale` is selected; retained runtime and
running percentage must accompany comparisons. Empty-window medians are a
scaffold control, not exact overhead to subtract from another process.
[Event options](allocation_pmu.py:68), [method limits](allocation-pmu-method.md)

## Companion verifier/analyzer requirements

- Recompute the complete ordered stat matrix: 70 unique processes, seven
  repetitions in each of five arm/case cells × alloc/empty. Recompute the
  conditional decision from those exact stat rows. Require exactly zero or
  35 ordered record processes according to that decision, with all attempted
  processes/auxiliary commands retained and no Complete on handled failure.
- Bind every row to its actual attempt argv/stdout, mode/case/index/arm,
  process duration, raw CSV/perf.data, byte artifact and frozen oracle. Recheck
  all complete bytes, capacity invariance, positive/finite counter coverage,
  environment/freeze/ELF identities and dates. Retain exact perf.data identities.
- Require the sampling cohort to reproduce its **own** prespecified opposite
  wall gaps before linking its symbols to the earlier phenomenon. The stat
  condition alone cannot authorize interpreting a changed sampling context.
- Summarize allocation and empty controls separately, with all pair directions.
  Report absolute sample-period weight and counts by exact DSO/symbol ranges,
  plus unknown/lost/throttled observations and sparse/zero-sample processes.
  Treat same-address aliases as one routine. Add synthetic parser/receipt
  mutation controls; no real benchmark reruns are needed for those controls.
- Freeze method, collector, verifier/analyzer, calibration and controls together;
  rerun primary/factor integrity verification without changing their manifests.

## Supported aspects and limits

The matrix arithmetic is correct: `(3+2) × 7 × 2 = 70` stat processes and
`(3+2) × 7 = 35` conditional sampling processes. Arm rotation direction is
independent of repetition, and mode order alternates. The conditional gate
requires both the favorable legacy and adverse v2 wall gaps with explicit
thresholds; it does not select only a favorable sample.
[Matrix](allocation_pmu.py:88), [condition](allocation_pmu.py:148)

The probe uses fixed File writes and a complete five-byte ACK read for both
commands, one enabled interval, a buffer that remains alive through exact
serialization, and an empty control that allocates after disable. The body is
statically refused under validation-work. Group-kill timeout/interruption
handling retains available output and addresses an ACK-blocked descendant;
the collector writes failure status and cannot declare Complete after those
paths. These are appropriate safeguards.
[ACK framing](allocation_pmu_probe.rs:14),
[window/consumer lifetime](allocation_pmu_probe.rs:69),
[group cleanup](allocation_pmu.py:29)

Counts cover the wider acknowledged PMU region, including user scaffolding;
the local wall clock also includes descheduling/kernel effects omitted by user
PMU events. If both gaps disappear under the new control/compiled context,
report that outcome and stop physical attribution. Even repeatable samples in
an exact allocator routine identify executed user paths, not a unique earlier
heap transformation, exclusive wall-time cause or cache/DRAM mechanism.

## Follow-up while still unfrozen

Re-read after the parent's changes: the controller now uses CPU6, the perf
workload launches through a CPU7 taskset wrapper before the Rust fixture, and
both affinities plus taskset identity are retained. The counter parser now
rejects duplicate/nonfinite tuples. The new companion
`allocation_pmu_verify.py` is included in the pending freeze; its source checks
require exactly four arms, expected binary paths, exact archive inventories,
matching probe bytes, reference record/store identities and every shared final
view source identity. These changes address the material parts of findings
1–3 and the missing companion in finding 4. Disassembly, effective environment
and additional raw metadata exports were still being prepared when reviewed.
[Revised controller and parser](allocation_pmu.py:26),
[companion source checks](allocation_pmu_verify.py:21)

Confirmed from the **pinned Linux v7.2.7 primary source** that setting
`PERF_CONFIG=/dev/null` isolates ordinary config-file loading: `perf.c` assigns
the variable to the exclusive configuration filename, and config initialization
returns after reading that file, before either system or user config branch.
An empty `/dev/null` stream therefore supplies no file options. Set and retain
this effective value for calibration, measured and auxiliary commands. It does
not eliminate compiled defaults, other environment settings or the default
build-ID cache location; those remain distinct controls.
[perf entrypoint](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/perf.c#L450-L455),
[exclusive configuration branch](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/config.c#L738-L750),
[build-ID cache default](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/config.c#L879-L897)

The companion has the following remaining concrete prefreeze/interpretation
items:

- Its current summary computes the gap decision only from stat rows. Add a
  separate decision over record rows, so the sampling cohort's own wall gaps
  explicitly govern physical attribution. A stat-triggered sampling campaign
  can be valid even if sampling erases its wall gap; that outcome must be shown.
- The sample-line regex uses `\S+` for symbol names. Demangled Rust symbols can
  contain spaces and consequently become unparsed lines. Current `sample_count`
  and `total_sample_period` sum only parsed lines. Parse the complete symbol
  span robustly, or label these recognized counts explicitly and retain an
  independent total/period denominator. Never omit unknown samples from a
  reported concentration percentage. Test spaced symbols and unknown DSOs.
- Auxiliary checks currently require only that argv contains the perf.data
  path. Bind the complete expected argv, stage/date and text receipt for each
  auxiliary command, including the forthcoming raw metadata dump. Retain and
  verify each perf.data identity alongside its reports; validate actual MMAP/
  build-ID/ELF correspondence before routine claims, including same-address
  alias treatment. The currently inspected summary scans report text for loss/
  throttle words; raw metadata must remain an additional authoritative source.
- The companion binds finite process durations but should also require
  nonnegative duration, exact indexed artifact/perf filenames, and unique
  perf.data references. These are inexpensive receipt-corruption guards.

[Current summary/parser](allocation_pmu_verify.py:42),
[current receipt checks](allocation_pmu_verify.py:80)

No test/build/measurement was run for this follow-up. The parent reports four
diagnostic builds completed and plans to preserve all four disassemblies.
Those build/assembly receipts and the final diagnostic freeze still require
their own final integrity verification.
