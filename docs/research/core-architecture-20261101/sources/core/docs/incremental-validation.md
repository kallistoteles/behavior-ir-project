# Incremental validation

The Store can reuse established complete-state validity for selected ordinary
transitions. All decisions, errors, canonical records, commands, state identities and
replay results retain the reference semantics. Reuse is an execution strategy, never
an admission restriction or an authorization to skip an unproved obligation.

## Supported route and obligations

Feature 029 covers live `Store::evaluate`, commit reproduction and the next evaluation
under the current complete-resulting-state profile. Its selected global obligations are:

- Literal Boolean module invariants.
- Exact typed `count(select(T)) <= K`, with an integer literal K.

Entity rules must have completely classified local dependencies. Scalar expressions
and positive synthesized Ref constraints support unchanged-row evidence reuse. Local
derived rules retain ordinary observer/memo computation; locality alone is insufficient
to substitute their evaluation evidence. Unknown or mixed unsupported global roots
select ordinary execution. Equivalent expressions outside the selected shape remain
executable with their existing semantics.

Updates preserve typed membership. Actual fresh, distinct creations extend it; Count
uses checked addition and the existing checked i64 conversion. Every affected row and
every global obligation remains covered. Physical removals and migrations do not carry
this update/create evidence into the next state. Cold open and incompatible contexts
establish validity through complete validation.

## Evidence and boundaries

Initial validation checks the complete typed state, identities, references, entity rules
and globals. Core-owned prepared state holds that checked content. It has no unchecked
constructor or deserialization authority. Store binds it to the exact Store/history
record, position, StateId, schema, complete module content and validation profile.
Equal counts, equal StateIds at different positions, or equal BehaviorHashes with
different admitted metadata do not establish that boundary.

Unchanged unbound row evidence originates in the ordinary Core row evaluator. Bound,
changed and created rows use their actual action context. Canonical ordering, skipped
steps, reads, numeric evidence and positive-reference observations remain intact.
Reproduction checks the entire submitted record against actual checked execution at
that exact parent. Shared execution evidence is immutable; sharing it copies no full
record or observation set. Fresh creation re-observes history-only used identities at
its existing reproduction boundary.

A child becomes reusable only after exact successful CAS. Refusal, conflict, uncertain
acknowledgement, incompatible context or shared mutable-state ownership grants no child
authority. The Store can discard optimization and rebuild instead of copying the entire
state solely to retain reuse. Existing retry and lost-acknowledgement recovery apply.

The correctness argument is conditional on the Rust implementation and Backend
completeness, immutable history and atomic publication contracts. It is not a
machine-checked proof of the compiler or host. Differential tests, independently
expected refusals and deliberate premise mutations check implementation correspondence.
See the [argument](../specs/029-incremental-global-validation/correctness.md),
[construct map](../specs/029-incremental-global-validation/construct-mapping.md) and
[recovery evidence](../specs/029-incremental-global-validation/evidence/us3.md).

## Costs and measured scope

The controlled corpus uses one growing InMemoryBackend Store per creation run, with
populations from 1 to 8192, fixed-population history controls, multiple global rules and
simultaneous creations. Release timings include evaluate, commit and a final evaluation
after publication; setup and whole-process totals are retained separately. Instrumented
runs attribute work and are excluded from numerical timing acceptance. Budgets and the
required growth improvement were frozen before production optimization.

All 103 frozen cases passed (927 retained observations). On the reference Linux host,
the eight-creation count-bound cycle at starting N=8192, including final evaluation,
has median 26.871 s for the released baseline and 19.107 s for the candidate (28.9%
less). The measured count-create growth slope is 31.0% lower than the frozen baseline.
Full snapshot-row checks in that measured steady-state cycle fall from 204,900 to zero;
initial validation is still required and measured separately.

The [evaluation report](../specs/029-incremental-global-validation/evaluation-report.md)
and its machine-readable acceptance record contain the actual results and remaining
limits. Performance claims apply to the specified platform, workload and route. Unified
invocation, declared reads, arbitrary filtered/relational queries and historical replay
retain their existing validation paths and have no new timing guarantee from this
corpus. They remain covered by semantic regression and replay tests.

Current records still archive the complete parent universe, canonical member observations
and per-child rule traces. Emission, parsing, comparison and hashing therefore require
work proportional to the evidence size. Real queries may require work proportional to
their candidates/results. Avoiding unchanged-row semantic validation does not make every
complete transaction constant-time or remove these existing output/history costs.
This output-size floor does not establish that every current copy, parse or allocation
is optimal. The report separates remaining record-processing overhead from repeated
semantic validation; further optimization of that overhead is possible.

Prepared state and execution evidence are ephemeral and reconstructible. They add no
persistent application state, events, record fields, Backend requirement or replay
dependency. Optional indexes retain their existing contract. Core replay works after
all prepared state has been discarded.
