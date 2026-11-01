# Optional phase-scoped PMU diagnostic

2026-10-31. Read-only method research. Inspected the installed perf 7.2.7
version/help/man pages and corresponding upstream sources; ran no builds,
counter collection, producer programs or benchmark measurements in this audit.
The existing [availability log](perf-availability.log) establishes only that
`cycles:u,instructions:u` opened successfully for its earlier `true` workload.

## Feasibility and exact control protocol

Yes: a separate Rust diagnostic producer can open its FIFO endpoints and
prepare static command bytes/stack acknowledgment buffers before fixture setup,
then enable and disable counting around O1. The installed program is
`/nix/store/12ns24zpsfih98b0q7k44n5ys86l789i-perf-linux-7.2.7/bin/perf`, obtained
through the previously pinned nixpkgs revision. Its `stat -h` and `record -h`
both advertise `--delay=-1` and `--control=fifo:CTL,ACK`. Initial delay -1 starts
events disabled; control requests enable/disable them and optionally acknowledge
completion. [Pinned stat manual source](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-stat.txt#L225-L264),
[pinned record manual source](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-record.txt#L743-L795).

Send one newline-terminated command at a time: `b"enable\n"`, wait for its ack,
then later `b"disable\n"` and wait again. An important source-level detail:
this version writes **five acknowledgment bytes `b"ack\n\0"`**. The header
defines the tag as `"ack\n"`, and the writer passes `sizeof(TAG)`, including
the C terminator. Reading only through newline leaves a NUL for the next
request. For this pinned version use `read_exact(&mut [0u8; 5])`, verify the
complete expected bytes, and reject any unexpected framing.
[ACK definition](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/evlist.h#L635-L645),
[ACK writer](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/evlist.c#L2226-L2240).

The FIFO parser opens both files using `O_RDWR|O_NONBLOCK|O_CLOEXEC`; the command
reader terminates at newline or NUL. Command handling calls enable/disable
before sending the acknowledgment. An acknowledgment is synchronization, not
a guarantee that every requested hardware event was successfully schedulable.
[FIFO and control implementation](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/evlist.c#L2033-L2082),
[command parsing](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/evlist.c#L2164-L2227),
[dispatch order](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/util/evlist.c#L2336-L2374).

## Proposed producer and collector boundaries

Use a separate source/binary identity, preserving the chosen legacy-shaped or
factor producer's semantic outputs. The controller creates fresh, uniquely
named FIFO files before launching perf. The producer opens each once with
read+write before fixture setup (Linux FIFO semantics avoid open-order blocking),
and allocates all path/argument/result storage there. Use unbuffered `File`
I/O, static byte slices, and fixed acknowledgment arrays. Avoid `read_line`,
formatting, dynamic logging, or control-buffer allocation between commit and
disable. The success-path control code need not allocate; the serializer may
still allocate its ordinary output. Establishing this control-code property
does not establish identical native allocator state. A pre-fixture `ping`
handshake can check synchronization and exercise the control code while events
remain disabled; freeze that choice across all arms.

The selected first-call region is:

1. Complete actual commit and the retained success checks.
2. Write enable and consume its full acknowledgment.
3. Start the existing wall timer; run exactly one selected serialization;
   capture its elapsed time while retaining the owned output.
4. Immediately write disable and consume its full acknowledgment.
5. Compare bytes, record results, copy/hash/write artifacts and drop output
   after counting is disabled. Repeats/parsed controls may then run uncounted.

For a presized writer, declare whether its setup belongs inside the enabled
region. To investigate the complete first extra serialization, enable before
buffer preparation and retain setup/write/total wall durations. A write-only
counter region is a different diagnostic and requires its own manifest.

Keep exactly one enabled region per process when using final `perf stat`
output. Re-enabling for O2/P1 accumulates additional work into the same final
counts and loses their separate attribution. Select O2/P1 in separate fresh
processes if needed, preserving the required preceding operations uncounted.
Use external timeout/process-group cleanup for failed handshakes and retain
the failed attempt; do not interpret missing ack or perf errors as zero counts.

A proposed command shape, not executed here, is:

```text
perf stat --delay=-1 --control=fifo:CTL,ACK --no-inherit --json-output \
  --output COUNTERS -e '{cycles:u,instructions:u}' \
  -- PRODUCER [fixed arguments]
```

Use process-scoped collection, without `-a` or CPU-wide counting. Pin the
producer to the existing CPU7 and keep perf's controller on another allowed
CPU where practical; retain both affinities and the launch wrapper. Otherwise
perf and producer share the measured CPU during synchronization. The wrapper
must not introduce work during the enabled region. Freeze binary/path lengths,
inputs, event set and order; rotate arm order across fresh process pairs.

The enabled PMU region is **slightly wider than the wall-timed serializer**:
it includes producer user instructions between enable and completion of its
ack read, wall-clock calls, call dispatch, and the disable request until perf
processes it. Waiting/scheduling also changes the machine state before O1.
Counters therefore describe a bounded instrumented region, not an exact
instruction boundary at the first serializer instruction. Hold output alive
until after disable so output destruction is excluded.

## Event sets and validity checks

Start with the already available paired user events. In separately frozen
passes, request `{branches:u,branch-misses:u}` and
`{cache-references:u,cache-misses:u}`; use `minor-faults` as a separately labelled
software event. The latter counts faults, not their duration. Check each event
set can open and schedule before collecting the campaign; listing an event
does not establish access. Do not collect an oversized hardware set and ignore
multiplexing. Retain perf stderr, raw counters, event-runtime and pcnt-running;
reject unsupported/not-counted events and disclose scaling. Ratios should use
simultaneously scheduled members and retained raw counts.
[Event modifiers and groups](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-list.txt),
[stat JSON fields](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-stat.txt).

The inspected local `perf list --details` resolves generic cache references to
CPU event `0x2e/umask=0x4f` and cache misses to `0x2e/umask=0x41`; its descriptions
warn these generally concern the last-level cache and vary with CPU design.
Retain actual CPU model/kernel/microcode and resolved event encodings. These
are not universal counts of every cache miss, and an LLC miss count alone
does not identify the responsible object, load instruction or stall time.
The local listing describes minor faults as faults that require no I/O.

If call paths remain necessary, run a separately identified `perf record`
pass with the same delay/control protocol, one user cycle event, a declared
sample period and `--call-graph dwarf,8192`. Preserve perf.data, exact binaries,
build IDs, unwind/debug data and sample/loss diagnostics. Default frame-pointer
unwinding can produce invalid chains when frame pointers are omitted; DWARF
records user-stack dumps and also adds overhead. Sparse samples from one
millisecond-scale first call do not yield a reliable hotspot distribution;
aggregate many independently retained fresh-process first-call observations,
not repeated warmed serialization masquerading as O1.
[Pinned call-graph documentation](https://github.com/gregkh/linux/blob/v7.2.7/tools/perf/Documentation/perf-record.txt#L294-L328).

## Required interpretation gate

Before associating PMU differences with the historical regression, verify
that the target arm gap still appears in this diagnostic's own O1 wall times
and equal bytes. Compare with the fresh historical/native anchors and an
otherwise identical diagnostic run without enabled hardware counters. Control
handshakes can erase or create the context-sensitive effect. If the gap
disappears, report that outcome; these PMU counts cannot explain the native
gap that failed to reproduce under their boundary.

If the gap survives, instruction/cycle/branch/cache/fault differences can
narrow hypotheses in that context. They do not alone prove an exact allocator,
cache, frequency or compiler mechanism. Keep source-supported removed work,
same-campaign operational resolution and any remaining physical uncertainty
as separate claims. No PMU claim is needed to adopt a validated operational
improvement whose measured complete consumer window meets the acceptance gate.
