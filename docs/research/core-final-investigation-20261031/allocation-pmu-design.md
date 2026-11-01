# Bounded allocation-window PMU diagnostic: design review

2026-11-01. Research only. Reviewed the proposed diagnostic and inspected
existing ELF metadata/symbols with installed binutils. No runtime source edits,
builds, producer runs, tests or counter/sampling measurements were performed.
The running frozen capacity/touch stage remains untouched.

The proposal is useful **if the broad setup gap survives its own changed
context**. It can locate execution inside the allocation interval and possibly
identify allocator routines carrying sampled work. It cannot by itself prove
the precise earlier heap transformation or a unique CPU-level cause.

## Window and empty control

Use a separately named diagnostic producer, with unchanged production library
source for decode A, guarded typed C and final view V. Freeze the exact arm
mapping rather than using A to ambiguously mean the original research base.
Select N512 legacy, the unchanged actual evaluate/commit fixture, and the same
frozen complete decision bytes. Read the expected Vec, open both control
Files, initialize acknowledgment arrays and prepare all result/path storage
before fixture creation.

After successful commit, send enable and consume **five** bytes
`b"ack\n\0"`; take Instant; construct `Vec::<u8>::with_capacity(L)`; take the
second Instant; immediately send disable and consume its full acknowledgment.
Keep the resulting Vec alive. Check its starting length/capacity, serialize
with `to_writer`, compare exact bytes and only then drop it, all after disable.
Use L from the preloaded frozen oracle, not a preceding serialization of the
original. Do not initialize, fill or prefault the Vec's backing storage in
this allocation window: those are different interventions. Allocation reserves
capacity; it does not establish the cost of writing every output page.
[Pinned control framing and boundary limits](pmu-method.md).

For the empty-window control, preserve the same clocks, command/ack protocol
and output lifetime: omit the capacity allocation inside the enabled window,
then perform it after disable before identical serialization/byte checking.
Choose the mode before fixture setup; equal-length names such as `alloc` and
`empty` avoid another avoidable argv allocation-length difference. Keep one
enabled region per process and rotate arm/mode order across fresh processes.
The empty window assesses the scaffold; subtracting its median cannot exactly
reconstruct a native allocation cost, because it need not induce the same
scheduling, counter or machine-state interaction.

The successful control path should use static byte slices and fixed stack
buffers with File read/write operations. No formatting, dynamic error messages,
result Vec growth, symbol lookup, proc-file reading or output occurs between
commit and disable. Serialization remains outside the counter window even
though it verifies/consumes the allocation afterward. Check release disassembly
to establish that the capacity allocation remains between the clocks; source
placement alone is not a guarantee about optimized allocation execution.
The allocated buffer's later use prevents treating it as dead source work,
but Rust's allocation contract still permits optimization.
[Allocation-contract caveat](https://github.com/rust-lang/rust/blob/48a229ceaefd4985c50990b14116b6d856af0985/library/core/src/alloc/global.rs#L90-L128).

## Instrumentation and validity gate

Start with separately frozen `perf stat --delay=-1` user
`{cycles:u,instructions:u}` collection using FIFO control. The PMU interval
includes some producer enable-return/ack-read instructions, both clocks and
disable-request tail until perf handles the command. It is wider than the
Instant allocation duration. User cycles/instructions omit kernel execution,
and do not measure time spent descheduled; a wall gap without a user-cycle gap
therefore does not establish absence of allocation-associated cost.
[User event modifier](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-list.txt#L55-L76).

Before interpreting counters, require complete byte equality and show whether
A/C/V setup differences persist in the diagnostic's own wall times. Retain a
separate no-counter diagnostic observation and the empty-window observations;
do not pool them with historical/native/factor cohorts. If opening/handshaking
or the new binary layout erases the gap, the PMU run cannot explain the missing
native effect. Report that outcome and stop the physical attribution claim.
The two user counters are known to open in the earlier availability check;
group scheduling and sampling permission still require their own receipts.

Retain raw stat JSON/stderr, resolved event identities, event-runtime,
pcnt-running, scale information, task affinity, attempted argv, return status
and timestamps. Reject unsupported/not-counted events. Low running percentages
or multiplexed short windows cannot be silently treated as full coverage.
Record perf's controller affinity separately from producer CPU7: placing both
on CPU7 changes the handoff state. Bound handshake failure by an external
timeout with cleanup and retain failed attempts. These controls add diagnostic
work even when no heap allocation occurs in the control code.
[Stat output fields](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-stat.txt).

## Symbolization is feasible, with precise limits

The existing view-serial ELF requests the loader in
`/nix/store/lm3pknxi0ipypy3lxh1wmm8wvvavdwrn-glibc-2.42-84/lib` and lists that
directory in RUNPATH. Inspection of that directory's `libc.so.6` found:

| ELF symbol | Value | Size | Binding/type |
| --- | --- | ---: | --- |
| `malloc_consolidate` | `0xaa5a0` | 456 | LOCAL/FUNC |
| `_int_malloc` | `0xac830` | 4,210 | LOCAL/FUNC |
| `sysmalloc` | `0xabfe0` | 2,113 | LOCAL/FUNC |
| `malloc`, `__libc_malloc` | `0xae8b0` | 455 | GLOBAL/FUNC, same-address aliases |

The file contains `.symtab`, `.dynsym`, `.eh_frame_hdr` and `.eh_frame`.
Its inspected build ID is `67802a55cff437269d8d9608af391b6f583fca73` and SHA256
is `b8cb091b34bdd88f6902eebff8761f9ea306e6789b4ac4d06d4470c0d568c80c`.
These are direct file observations, not evidence that any routine executed in
the measured allocation. The ELF symbol table supplies names, values, sizes
and function types; local binding does not prevent offline symbolization from
the containing file. [Inspected libc](/nix/store/lm3pknxi0ipypy3lxh1wmm8wvvavdwrn-glibc-2.42-84/lib/libc.so.6),
[ELF symbol specification](https://gabi.xinuos.com/elf/05-symtab.html).

Function-level sampled-IP attribution is therefore feasible without fetching
a new debug package, provided perf retains this exact DSO and its mappings.
The current executable's RUNPATH also has an output directory first; existing
metadata does not prove which libc a future diagnostic actually loads.
Retain the new executable's interpreter/RUNPATH and actual runtime mappings,
mapped DSO paths/build IDs/hashes, allocator selection and relevant
`LD_PRELOAD`, `LD_LIBRARY_PATH`, `GLIBC_TUNABLES` and malloc environment settings.
Prepare any mapping capture before fixture setup and emit it after disable.
Do not substitute symbols from another glibc build having the same version.

## Bounded sampling and interpretation

Use a separately identified `perf record` pass with the same one-window
protocol, one user cycle event, a fixed prespecified period and no initial
call-graph dump if sampled-IP function localization answers the question.
This avoids immediately adding per-sample user-stack copies. Keep raw
perf.data, sample timestamps/periods, lost/throttled-event diagnostics, exact
ELFs and build IDs. Metadata records may exist outside the enabled interval;
restrict interpretation to the selected sampled event and controlled window.

A fast V allocation may receive very few samples at a period suitable for a
multi-millisecond A allocation. Report actual sample counts and uncertainty;
aggregate multiple fresh-process first-allocation windows rather than warming
one process to manufacture samples. Compare absolute retained sample-period
weight as well as within-run percentages: a high percentage from two samples
is not strong evidence of a dominant routine. Sampling overhead can itself
alter the wall gap and must be checked independently of stat.

If caller attribution is necessary, add a separately declared DWARF call-graph
pass with retained unwind data and validate chains. `.eh_frame` supports the
possibility of unwinding but does not guarantee complete chains, source lines
or inlined-function recovery. Default frame-pointer unwinding is unreliable
when frame pointers are omitted; DWARF stack dumping adds substantial work.
[Pinned call-graph documentation](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-record.txt#L294-L328).

If the gap persists and samples land repeatedly inside an exact symbol range,
the report may state that sampled user-cycle work in this allocation-window
diagnostic is concentrated in that allocator routine. The glibc source can
then explain what the routine does, with Nix patches/build identity retained.
[Upstream allocator source](https://github.com/bminor/glibc/blob/glibc-2.42/malloc/malloc.c).
That finding still does not uniquely identify which earlier allocations/frees
created its state, prove a cache/TLB mechanism, quantify uncounted kernel work,
or license extrapolation to every consumer. Lack of samples in a fast window
does not prove a routine was never called. The existing source-local setup
finding and any validated operational remedy remain useful if this bounded
diagnostic cannot resolve the physical mechanism.
