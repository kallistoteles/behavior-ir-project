# Prespecified final measurement matrices

Defined before collecting any final-candidate performance samples. Actual source,
binary, input and control hashes are frozen separately once all gates finish.

## Native and complete observations

Six cumulative arms: original research base; strict-decode reuse; guarded typed
reuse; typed plus bundle move; move plus buffered Core hash streaming; streaming
plus borrowed Store views and reuse of already-owned v2 candidate content JSON.

Native cases are (N, command emissions): (128,0), (512,0), (2048,0), (8192,0),
(128,2), (512,2). The two command cases exercise actual v2 history rather than
extrapolating from legacy no-command timing. Seven fresh processes per arm/case,
rotating/reversing order:252 native attempts. Each emits the complete decision
and committed event/head/result, with expected bytes fixed from the original
arm before measurement. The four legacy decisions also match prior frozen
oracles. Native timers cover evaluate, commit and first original Value Display
serialization; the wider process includes additional event hashing/serialization
and artifact capture and must be labelled accordingly.

Three existing full-observation cases in every arm add18 attempts. They must
match the older frozen ordinary, commands/references and history/update outputs.
Total270 attempts and90 representative gzip artifacts (72 native decision/event,
18 full observations). This is the final cumulative comparison; primary final
comparison is view versus original, with incremental adjacent-arm results kept.

## Sink factors

Decode/typed/moved/view × N128/N512 × Display/to_vec/to_writer128/to_writer-full
×7 repetitions:224 fresh processes. Select one sink per process; four original
calls then four fresh-parsed calls, all compared to fixed complete bytes. Each
process supplies O1, medianO2–O4, P1 and medianP2–P4. Setup/write/total durations
are separate; preallocation is never free in a consumer-total claim. Presized
writers must retain their capacity. One actual O1 byte copy occurs after timing,
and output Strings/Vecs are dropped before the next call. This expanded probe's
context differs from the historical/native driver; do not merge those timings.
The optional touch intervention is sham in this first stage. Sink order rotates
and reverses within each repetition, as does arm order, so matched capacities
are not collected in separate seven-repetition time blocks.

Conditional next stages are selected from declared hypotheses, not faster
individual samples: matched preallocated Display sinks if adapter versus growth
remains ambiguous; allocation-free input-touch versus sham on unresolved Display
and presized-writer cases; phase PMU diagnostics only if physical interpretation
needs more evidence. Each such stage gets its own precollection manifest and
retains failures/adverse results. PMU availability has been established, without
treating whole-process counts as first-serialization counts.

## Historical native anchors

Retain the exact older decode, typed and moved phase executables to recheck the
historical first-serialization result under their original prefix (which does
not preload an expected-record Vec). Add a final-candidate legacy-shaped probe
with equivalent normal-build operations; the research diagnostic-only scaffold
is removed and feature-enabled runs are explicitly rejected. N128/N512 ×4 arms
×7 repetitions:56 additional fresh processes and8 representative decisions.
Report these separately from new native/sink factors. Frozen byte oracles remain
the same. This prevents a changed benchmark prefix from silently erasing an old
observation.

All stages execute equal-length binary aliases and use fixed-width scratch
output arguments within a probe role. These control avoidable argument-size
differences. The historical anchors retain actual old executable bytes and
their normal source operations; aliases, output paths and machine state differ
from historical executions. They are not an assertion of identical compiled
execution context. All capacities reported before Display/to_vec are inferred
from pinned source; before-capacities of explicit writers are observed.

Premeasurement review corrected the order function: rotation advances once per
repetition, while reversal direction is fixed by case/index parity. Choosing
reversal from repetition parity had accidentally confined each arm to even or
odd positions. The corrected seven-repetition schedule visits every position
for every arm and sink; the incomplete extra cycle is retained, rather than
described as perfect balance. Process elapsed time is sampled once after child
communication and is identical in the attempt receipt and analyzed sample.
Each collector verifies the frozen inputs before starting and records the
precollection digest. Verification also binds environment/resource declarations,
oracle provenance, source archives, build identities and historical anchor hashes.

The initial fixed performance stages total550 processes. Six original-arm
reference-generation controls and two intentional wrong-oracle failures happen
before freezing, are retained separately and are not performance samples.
No hardware-cause claim follows solely from sink capacities, equal allocation
counts, instruction counts or improved medians. The solution must identify a
tested operational path while leaving any unproved physical attribution explicit.
