# Follow-up factor experiment: precollection review

2026-11-01. Read-only review of the staged `factor_followup.py`,
`factor_controls.py`, `factor-method.md` and their unchanged primary producer,
schema validator, analysis and verification dependencies. The supplemental
stage was not frozen or run when inspected. No source edits, builds, tests,
producer executions or measurements were performed by this review. This note
is new; it does not revise any primary frozen artifact.

**The staged collection and analysis are sound for the bounded questions
declared. No blocking implementation defect was identified.** The H4 wording
qualification raised during review was incorporated before freezing; this
review includes the revised method and verifier checks.

## Matrix and ordering

The stated totals agree with the source:

| Component | Count |
| --- | ---: |
| Legacy arm/cases: N128/N512 × decode/typed/view | 6 |
| Command-v2 arm/cases: N128/N512 × original/view | 4 |
| Sink × intervention × repetition per arm/case | 4 × 2 × 7 |
| Fresh processes | 560 |
| Four original plus four parsed rounds per process | 4,480 |
| Complete representative decisions, repetition zero | 80 |

The matrix records every tuple in execution order and is checked exactly by
the verifier. Sink, intervention and arm rotations occur within repetitions;
this avoids collecting all seven observations of one capacity before the
other. Rotation direction is independent of repetition, avoiding cancellation
of two-arm position rotation. Seven repetitions visit every arm position but
do not provide perfectly equal position counts. Cases remain blocked, so
cross-case timing differences should not be interpreted as controlled changes
in population or command mode.
[Matrix and ordering](factor_followup.py), [matrix control](factor_controls.py).

## Schema, outputs and freeze binding

The command-v2 schema adapter first asserts the **actual** emitted command
count against the selected case. Only afterward does it copy the row with
commands zero to reuse the frozen common round validator. A wrong emitted
command count therefore cannot be hidden by adaptation. The frozen producer
also consumes the actual commands argument in fixture creation. Complete
expected bytes provide the substantive command-output check beyond this
metadata check. The control log records a negative command-mismatch case;
this review did not rerun it.
[Adapter and controls](factor_controls.py),
[producer](serialization_factor.rs), [recorded controls](factor-controls.log).

Every process receipt must contain the eight declared object/ordinal rows,
normal-build mode, correct byte lengths, integer nonnegative times, exact
setup+write=total, and unchanged full-buffer capacities. Touch adds an integer
nonzero checksum sanity check; sham must retain zero. A nonzero checksum is
not by itself proof that every byte was physically fetched, but the inspected
walk visits all supported Value variants and its result remains live.
[Common validator](serial_collect.py), [supplemental validation](factor_followup.py).

The supplemental freeze binds the ordered matrix, collector/analysis code,
controls/log, method, primary verification result and completed primary
summaries. Its primary-freeze digest transitively binds imported helper code,
producer source, executed binaries/aliases and expected decisions; the primary
source check is rerun before supplemental collection and verification. This
is an appropriate additional manifest, with no need to change the primary
freeze. Freeze only after the current method wording and review decisions are
settled, and do not edit bound sources afterward.
[Supplemental freeze](factor_followup.py), [primary binding](common.py).

Verification checks exact matrix order, one successful retained attempt per
row, execution argv, receipt fields, post-freeze attempt timestamps, normal
resource limits, current binary/oracle identities, complete representative
bytes and artifact inventory, and recomputed analysis. Failure records prevent
Complete interpretation. Non-representative decision files are checked before
deletion; all-round equality is additionally enforced by the bound Rust
producer. This is consistent with the primary evidence model, rather than
retaining all eight round outputs as separate artifacts.
[Verifier](factor_followup.py), [shared verification](verify.py).

## Analysis and charged costs

Arm contrasts match each candidate/reference by case, sink, intervention and
repetition. Sink contrasts hold case, arm and intervention fixed; touch
contrasts hold case, arm and sink fixed. The grouping helper requires exactly
repetitions 0–6 for both sides, retains every pair, reports ratios of process
medians separately from paired ratios, and counts adverse pairs. Original and
parsed repeats are first summarized within their own process; the eight
calls are not treated as eight independent process samples.
[Supplemental contrasts](factor_followup.py), [grouping](analyze.py).

Setup/write/total remain separate observed intervals. The added
`o1_plus_touch_ms` correctly sums touch and O1 total **within each process**,
and `first_consumer_ms` adds evaluate and commit to that same sum before
aggregation. This exposes a traversal intervention that improves O1 but costs
more than it saves, without burying its cost inside a larger commit gain.
Presized allocation is already included in O1 total. Whole process remains
a distinct workload containing repeats, parsing, checks and artifact capture.
[Per-process metrics](factor_followup.py).

The primary setup/write split usefully localizes the broad arm difference to
the presized writer's pre-write interval. In the bound producer, that interval
contains mode dispatch, Vec construction/allocation, capacity observation and
the second clock read; it ends before `to_writer` begins. It is not an isolated
measurement of an allocator routine. O1 total is observed directly, so do not
reconstruct a median total by adding separately reported median setup/write
values.
[Timer boundary](serialization_factor.rs), [selection evidence](factor-method.md).

## Inference limits and resolved wording refinement

H4 proposes persistence of setup differences after an allocation-free input
walk. That is a useful specific hypothesis. Persistence is **not a
necessary consequence of every allocation-history explanation**: an input
walk can change cache residency, execution/frequency state and scheduling
before a later allocation, despite making no heap calls itself. The revised
method now describes H4 as testing whether the existing setup difference
persists under that intervention and acknowledges these alternatives. Either
persistence or reduction is valid evidence; neither alone identifies the
responsible allocator or CPU mechanism. The verifier also now checks the
environment timestamp against the supplemental freeze and the assessment's
declared 560 attempts; the retained log records the five controls passing
again after those changes.

The other intended interpretations are appropriately bounded:

- Display128 versus Display-full holds the formatter entrypoint fixed and
  tests sensitivity to the requested output-capacity policy. Initial
  allocation and later growth move between different intervals; total and
  touch-inclusive metrics determine any operational benefit.
- Writer-full versus Display-full compares whole full-capacity sink paths:
  formatter entry/adapter and String-versus-Vec writing remain different.
  It does not isolate one adapter instruction or one allocator effect.
- Touch happens only before original O1. Parsed calls occur after original
  repeats, output copying/destruction and parsing; their context is not a
  symmetric direct touch intervention on a second cold object.
- Mode strings and the supplemental output directory still differ from
  primary argv prefixes. Fixed-width scratch names and binary aliases control
  lengths within this stage, not equality of all histories across stages.
  Keep these cohorts separate as the method requires.
- The N128 command-v2 first-Display regression remains adverse primary
  evidence even if another sink or supplemental context improves. A faster
  evaluate+commit+serialize total does not erase that phase result.

The method supports an operational capacity/sink recommendation if complete
charged costs improve with equal bytes in this campaign. A universal allocation
explanation, exact cache/TLB/frequency cause, or hardware attribution still
requires evidence beyond this matrix. PMU work can remain conditional rather
than being treated as necessary to acknowledge an empirically useful remedy.
