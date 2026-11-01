# Final allocation-window diagnostic

2026-11-01. Prepared before diagnostic calibration or primary PMU measurements.
All550 primary and560 factor processes already passed their complete-byte and
inventory verification. Their code, binaries, data and manifests remain immutable.
This diagnostic is a separately built research example; production library
sources remain exactly those in the frozen stage archives.

## Question and boundary

The factor stage places the broad N512 legacy setup difference before JSON
writing: full writer sham setup is3.2590ms(decode),3.0789ms(typed),0.1295ms(view),
while write is1.2388/1.2138/1.1990ms. N128 command-v2 reverses the setup result:
original0.0391ms versus view0.4034ms, write0.3168versus0.3237ms. Allocation-free
input touch does not erase either setup difference, and costs more than it
saves overall. Both positive and adverse cases must be profiled.

The new example performs actual create/evaluate/commit, then enables perf,
waits for the exact5-byte `ack\n\0`, clocks one `Vec::with_capacity` and a live
black-boxed reference, clocks its completion, and disables perf with another
acknowledgement. That buffer stays alive through later to_writer and full-byte
comparison outside the PMU window. A separate empty-window process uses the
same control/clocks but allocates after disable. Control files, argument strings
and expected bytes are prepared before the fixture. No canonical/allocator
counter feature is enabled. Inspect release assembly to confirm allocation
stays between the clocks.

Counters include the enable-ack return, local timer/control instructions and
disable-command tail. They exclude kernel cycles and descheduled time; local
wall time still includes them. Empty windows bound scaffolding magnitude;
never subtract their medians as if they were exact overhead. This is a new
compiled context and control history, not a measurement of the original binary.
Only use it to explain that source-level phenomenon if the two opposite
allocation gaps reproduce under instrumentation.

## Prespecified matrix and conditional sampling

First collect70stat processes: N512c0×decode/typed/view, N128c2×original/view,
crossed with allocation/empty windows and seven repetitions. Use only user
cycles and instructions together; preserve per-event run time and running
percentage and require at least99% running, rather than silently accepting
multiplexed/unavailable counts. Retain each exact command, stdout/stderr, raw
CSV and complete decision bytes. Rotate arm positions independently of reversal
direction; alternate mode order. Each current arm visits every position.

Then collect35additional allocation-window IP-sampling processes only if BOTH
median diagnostic wall gaps reproduce: N512 decode exceeds2×view and0.5ms;
N128c2 view exceeds2×original and0.1ms. Preserve the condition decision even
when false. Sample user cycles at997Hz without callchains, seven fresh
processes in each of the five arm/case cells. This directly localizes sampled
instruction pointers with less perturbation than DWARF stack copying. Keep
all perf.data files, script output with periods/IP/symbol/DSO, reports, build-ID
lists and warnings. Verify each sampling cohort's own wall gap before linking
its symbols to the phenomenon. Very short windows may yield zero/few samples;
report counts and period weights, not an inferred zero cost. Do not hide lost,
throttled, unrecognized or unsymbolized observations.

The libc ELF named by the primary loader has local malloc_consolidate,
_int_malloc and sysmalloc symbols, so function-IP attribution is possible.
Bind the actual diagnostic binary's DSO path/build-ID and file SHA before any
routine claim. Same-address malloc aliases are one routine. Samples establish
executed CPU paths within this window; they do not prove exclusive wall-time
causation, a specific cache/DRAM mechanism or universal allocator behavior.

## Execution and integrity

The pinned perf7.2.7 executable and libc file SHA, four diagnostic binary/source
archives, method/collector/control sources and calibration outputs are frozen
before the70stat processes. The unchanged primary and factor freezes are bound
by SHA. No builds/tests run during measurement. One process at a time, CPU7,
8GiB virtual-memory limit,180-second timeout. The runner starts a fresh process
group and kills the group on timeout/interruption so an ack-blocked child cannot
survive a killed perf parent. All handled attempts and available files remain;
failure cannot write Complete. Auxiliary symbol reports run after measured
children stop. Perf and auxiliary reports run onCPU6; taskset moves the target
toCPU7 before its fixture begins. Both placements are recorded and taskset's
identity is frozen. Complete verification precedes the consolidated recommendation.

All calibration, measured and auxiliary perf commands use
`PERF_CONFIG=/dev/null`. In the pinned source this takes the exclusive config
file branch before system/user config loading:
[perf.c](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/perf.c#L450),
[config.c](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/config.c#L738).
Other selected PERF/LD/GLIBC/MALLOC environment settings are recorded and bound;
this is not a claim that every compiled default or the build-ID cache is absent.
Actual recorded MMAP/build-ID metadata and frozen ELF hashes govern DSO claims.
