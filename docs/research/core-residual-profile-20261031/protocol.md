# Residual phase profile and serialization context experiment

Prepared 2026-10-31 before implementation or collection. The guarded C source is
the tested candidate from `../core-typed-record-20261031`. Its source snapshots,
patches and previous measurements remain unchanged.

## Questions

1. Which elapsed costs remain in C's evaluation, commit and ready-record
   serialization, separating materialization, common semantic validation, exact
   comparison, canonical checks/serialization and tagged digest work?
2. Do the earlier small-population serialization regressions persist on the
   first post-commit call, repeated calls on that object, or a freshly parsed
   representation of the identical bytes?

These are diagnostic questions. No production optimization or new semantic
contract is introduced by this continuation.

## Phase profile

Use an isolated source checkout with the exact guarded C record implementation.
Add nested elapsed scopes only in the optional validation-work diagnostic build.
Keep root evaluate/commit/extra-serialization windows separate. Record scope
calls, inclusive/exclusive nanoseconds and the existing work counters. Split
typed parsing, common field movement, common validation, exact comparison,
header/final assembly, document-to-Value construction, canonical validation,
canonical serialization, top-level-hash exclusion cloning and tagged digest work.
Preserve all original expressions and their order.

Both diagnostic byte counters perform extra serialization. Name those costs
separately and introduce an explicit diagnostic-only byte-count switch. It may
change those counters alone. Compare one scoped binary with byte counts enabled
and disabled; call/row counts remain active. Disabled counts must be zero and
all normative bytes/hashes must match. Parent/child elapsed scopes include
bookkeeping overhead; neither subtracting named diagnostics nor summing nested
inclusive times reconstructs an uninstrumented run.

The matrix is populations 128, 512, 2048, 8192 × three fresh-process repetitions
× three modes: retained uninstrumented C, scoped C with byte counts, scoped C
without byte counts. Rotate the three modes by repetition. There are 36 attempts.
Use the unchanged single-create fixture and retain all complete decisions.
The diagnostic driver adds root scopes and reports its explicit byte-count mode.
Every decision must match the retained uninstrumented decision at that population.

Before collection, observe calibration failures on a no-op profiler, then verify
nested partition arithmetic, call counts, disabled/reset behavior, early-error
cleanup, canonical-error precedence and both document byte counters. Retain
relevant canonical/record controls and frozen-validator comparisons on the scoped
source. This is instrumentation conformance, without a new production-gate claim.

## Serialization context experiment

Build the same new probe against source A (the prior strict-decode improvement)
and guarded C, with normal release settings and no diagnostics. Their input
records are the byte-equal retained population decisions.

Each process performs the unchanged actual evaluate/commit and then:

1. Time O1: the first `Value::to_string()` on the returned original decision,
   before parsing or walking that value for equality. Compare its output after
   timing, retain a copy of its bytes outside timing, then drop the String.
2. Time eight calls total on the original object and eight on a fresh Value
   parsed from O1 bytes outside timing. Compare every output after its timer,
   drop each String before the next call, and check logical Value equality only
   after the parsed object's first serialization.
3. Use three schedules: blocked original O1…O8 then parsed P1…P8;
   O1 then alternating original/parsed repeats; and O1 then alternating
   parsed/original repeats. The last two retain eight calls per object.

The matrix is N128/N512 × A/C × three schedules × ten fresh-process repetitions:
120 attempts. Alternate arm order by repetition; retain each individual call.
O1, P1 and each process's O2…O8/P2…P8 medians are distinct statistics. Repeated
calls are not independent process samples. Parsing creates a fresh object, with
its own allocation/touch history; it does not imply a cold hardware state.

Schedule omission/duplication and wrong bytes must fail controls. No preallocated
writer or alternative serializer is introduced in this minimal experiment.
Persistence or disappearance in one context can narrow hypotheses, without
establishing allocator contention, cache misses or a compiler mechanism.

## Shared measurement and preservation rules

Use CPU 7 for each child, an 8 GiB address-space limit and 180-second timeout.
Run one measured process at a time after all builds/tests finish. OS cache is not
flushed. Preserve every attempted command, status, stdout/stderr and failure;
an interrupted/incomplete corpus cannot be Complete. Freeze source, binary,
protocol and collector identities before measurements. Keep this campaign's
results separate from all earlier timings, and report adverse observations.

Original and scoped output must match exactly. Work counters and timings do not
enter Core records. The work remains isolated research; the owning repository's
normal feature and workspace gates govern any later production adoption.
