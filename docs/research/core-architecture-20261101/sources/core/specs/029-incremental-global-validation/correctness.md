# Conditional correctness argument for Core 029

Status: implemented conditional finite-state argument with explicit trusted Rust and
Backend boundaries. This is not a machine-checked theorem or an end-to-end implementation
proof. Concrete G1/G2 mappings and correspondence tests are recorded in the linked evidence;
US2 mutation and US3 recovery controls supplement them. Tests cannot establish the
arbitrary-state quantifiers below.

## Subject and observations

Fix one admitted module M, semantic/validation profile and a finite complete typed
state S. Store reuse additionally fixes the full history/schema identity. Let delta
be the actual ordinary evaluated transition, not an untrusted proposed bundle.
Compare complete observable Results, including errors and normative phase ordering,
canonical observations/traces/commands/records and commit outcomes. Internal work and
hypothetical failures of omitted Backend calls are excluded by the constitution;
performed operations retain their contracts.

The initial optimized domain is updates and fresh creations, no removals/migrations,
with completely classified local entity rules and literal/unfiltered typed cardinality
global rules. Unsupported constructs remain executable via ordinary reference behavior.

## Established premises

1. Full bootstrap establishes the exact parent's validity and canonical typed content.
   No count, marker, externally submitted Boolean or expected future success substitutes
   for that check. A Core-owned opaque value records checked content; Store binds history.
2. Complete dependency analysis resolves actual declarations/calls under the admitted
   profile, including all branches. Unknown is affected/reference, not irrelevant.
3. Every actual effect is included. Creates have fresh distinct typed identities, values
   and Ref obligations obey ordinary Core checks, and simultaneous effects form one S'.
4. Omitted row obligations depend only on their unchanged typed row and the specific
   synthesized positive Ref guarantee preserved by no removal. Arbitrary existence,
   reverse reference, history, filtered query or captured dependencies are not local.
5. Cached observer contributions are derived from ordinary evaluation and satisfy the
   expression/frame correspondence below; validity alone does not establish this fact.
6. Published child reuse follows only exact successful CAS. A pending candidate has no
   authority for another head, context or an uncertain publication outcome.

These premises are obligations for implementation and tests, not assumptions that the
desired child validity or an eventual commit succeeds.

## Lemma 1 — Unchanged local obligation Result

For an unchanged row k and a completely local expression e, every typed field/parameter
input to e has the same value before and after delta. Structural induction over supported
scalar expressions therefore preserves the complete evaluation Result. Checked arithmetic,
partial operators and lazy activation are included: equal operands and equal branch
conditions imply the same value or error and the same active operands. Resolved derived
calls require the same property for their full binding-correct body closure.

For a synthesized Ref constraint, a surviving reference's target existed in the valid
parent. With no removals it still exists in S'. New/changed references are not covered
by this omission argument and must be checked against the complete simultaneous child.

Thus an omitted unchanged row's ordered failure contribution remains empty. This is
not permission to omit a rule whose dependency analysis merely failed to find a read.

## Lemma 2 — Affected cardinality

Let U_T(S) be the exact finite live identity set of declared entity type T. Let C_T be
the actual fresh distinct creates of that type. Under the no-removal premise:

    U_T(S') = U_T(S) disjoint-union C_T
    |U_T(S')| = |U_T(S)| + |C_T|.

Updates and creates of other types preserve U_T. The exact count summary is initialized
from complete validated membership, then advanced from actual checked effects. Checked
host-count addition and the existing checked conversion to Core i64 must agree with
ordinary Count; conversion failure cannot become a successful mathematical-integer
comparison. A failed representability premise uses the exact ordinary error/fallback.

Comparing that exact count with the same typed literal K establishes the same truth or
error as the selected count rule. For K=1000 and999 existing identities, one fresh create
passes; after its successful commit a further create fails. No unchanged row needs a
new local-rule evaluation to establish either result. An invalid changed row still
receives its ordinary failure; a count result cannot suppress it.

## Lemma 3 — Complete validation result

Write snapshot validation as canonical ordered row contributions followed by ordered
global contributions. Each omitted row has empty contribution by Lemma1 and valid S.
Each unaffected global has its complete inputs/definedness preserved by covered
dependencies. Each affected count has the exact contribution by Lemma2. All changed
rows and all other applicable obligations retain ordinary semantic checking or fallback.
Ordered concatenation therefore equals full snapshot validation, including every error.

Action evaluation uses a different fail-fast/skipped trace contract. Lemma3 alone does
not justify its reuse; the observer obligation below is separately required.

## Observer and frame correspondence obligation

Reusing a successful Boolean is insufficient. For each reused expression, establish
equality of its value/error and ordered semantic read/derived/trace effects in the actual
action context. Only unchanged unbound subjects can use an action-independent row template;
bound/changed/created subjects retain ordinary context-sensitive evaluation.

The induction must preserve field attribution, phase coordinates, canonical subject and
obligation identity, locations/text, checked numeric encodings, rescale entries, first
failure and skipped entries. Derived memo hits/misses are semantically observable through
derived evidence: blindly appending a cached list is unsound. Either replay the exact
ordinary memo/frame effects with established correspondence, or use reference execution
for constructs whose observer correspondence is not established. Complete universe and
query-member evidence must still be emitted; their output-sized traversal is legitimate.

The implemented G2 template path uses the ordinary `run_child_row` helper for both
successful and skipped traces. Its eligible scalar constructors have no derived memo
mutation. It replays exact operand writes and immutable-parent field observations;
synthesized Ref observations follow `exists_s`'s bound-target suppression. Changed,
bound and newly created rows use actual ordinary evaluation. Any row with a derived
call retains ordinary computation, avoiding an unproved observer/memo correspondence.
See evidence/g2.md for the exact supported domain and implementation mapping. This is
conditional reasoning about trusted Rust, not a machine-checked implementation proof.

## Execution, reproduction and publication

Core's checked constructor establishes semantic evidence; Store contributes exact history
identity and continuity. Request decoding, binding consistency, freshness, history-only
used-identity evidence and independent integrity/governance checks retain their ordinary
phase and contract. The optimization cannot introduce an earlier refusal just to prepare
evidence. Absent/incompatible evidence selects reference execution.

Commit independently reconstructs the request/effects and complete expected record against
the actual exact parent. It must not trust the proposed changes or a producer's approval.
Prepared child evidence remains speculative until exact Applied CAS; conflicts, uncertain
acknowledgement and incompatible heads discard it. Existing recovery establishes the
actual head before reuse. Cold reopen, migration and incompatible modules re-establish
ordinary validity; no cache becomes persistent application truth or a replay dependency.

## Remaining trust and acceptance

Core semantics/admission/canonicalization, complete effect/dependency extraction,
observer correspondence, evidence maintenance and Backend completeness/atomicity remain
trusted implementation boundaries. Feature015 supplies conditional local reasoning;
external verified IVM mathematics does not prove this Rust implementation. Independent
full-state reconstruction, explicit expected valid/invalid/error cases and deliberate
premise mutations test correspondence but do not remove these trusted boundaries.

G1 requires concrete closure of observer/evaluator/reproducer correspondence. G2 requires
the implemented membership/frame mapping. G3 requires adversarial and recovery controls;
G4 separately requires unbiased frozen-profile performance evidence. This argument grants
neither certification of an unimplemented path nor completion based on a faster counter.

## Closure and explicit limits of the argument

The constructor establishes the parent premise through the unchanged complete checker.
For each admitted scalar constructor, equality of row inputs establishes equality of
value/error and lazy operand activation by structural induction. The shared ordinary
row helper produces the actual cached trace; no guessed `true` step is constructed.
Unchanged unbound rows have no outer action binding, so field observations and operand
writes replay in canonical row order. After a prior failure, only the ordinary skipped
trace is used and no successful observer contribution is installed. Preflight typed-key
checks remain before all child evidence. Positive synthesized references use the
no-removal argument and the same bound-target existence suppression as ordinary Core.
Derived memo-bearing rules retain ordinary execution rather than invoking this lemma.

Count uses exact typed membership, checked distinct creation addition and ordinary i64
conversion; it does not change expression values or suppress member observations. Unknown
constructs or mixed unsupported roots select reference behavior. Every actual transition
comes from the ordinary interpreter's complete World, avoiding an independently authored
inventory of actions/effects. The Store compares the whole reconstructed record and its
products, then publishes reusable child evidence only after exact Applied CAS. Core's
allocation epoch is not a substitute for Store's complete history/profile binding.

The trusted components remain admission/canonicalization, ordinary evaluation, the new
classification/template/delta implementation, Store correspondence and Backend contracts.
The mathematical argument is conditional on their faithful implementation; six deliberately
broken premises are detected by tests but do not discharge those trust assumptions.
No Lean/SMT claim, automatic migration theorem or external host safety claim is added.
See evidence/premise-mutations.md, evidence/us3.md and the final performance report.

Checked execution evidence is immutable and shared, including its complete expected
record and observers. Sharing has no state-transition authority beyond the original
exact parent epoch. Reproduction still parses and checks the full untrusted record;
it borrows the known expected record for comparison rather than copying it solely to
keep reuse. Existing trace helpers drain numeric rescale evidence at each active rule,
effect and condition before the next child row; templates preserve the same per-rule
entries. The pointer-sharing regression establishes the intended ownership strategy,
not a new mathematical safety premise.

Child promotion can consume the native parent-record identity and the child identity
already computed by commit after exact reproduction. Its fast path compares all cached
parent identity coordinates and the actual checked Core record. It introduces no public
producer capability: native commit remains responsible for faithfully supplying its own
computed results, and exact Applied checks still establish the actual child. Redundant
reparsing or rehashing does not discharge an additional semantic obligation. See
`evidence/promotion-remediation.md` and its red/green work control.


The exact module comparison is computed once per prepared evaluation. A private
call-scoped token holds the compared immutable Module borrow and the checked parent;
the evaluator additionally requires the same Module address for that token. The address
is only a correspondence check inside this immutable borrow, never an alternative to
the full-content comparison or a persistent module identity. The actual full module
encoding also binds the resulting checked execution. A separately allocated Module
with identical full content can establish its own token; equal BehaviorHash with
changed metadata cannot. Ordinary/archived entrypoints retain their ordinary path.
This removes duplicate serialization, without weakening module/history premises.


Promotion first checks whether either the retained015 locality analysis or selected029
coverage could establish a carry. If neither applies, it returns no evidence before
record parsing or parent re-establishment. This is conservative withdrawal, not an
additional validity premise or authorization. Ordinary evaluation/reproduction/commit
checks remain unchanged; old eligible local modules are included by the union. See
`evidence/fallback-remediation.md` and its actual failing Backend-read control.


The ordinary fallback retains its actual owned Core DecisionRecord until the enclosing
Store evaluation returns, as before029. This immutable, already computed value grants
no reuse authority. Restoring its allocation lifetime changes neither execution nor
its record/observer/bundle values; prepared evaluation retains no additional ordinary
record. See `evidence/fallback-lifetime.md` for the complete failed timing control and
paired investigation. This is a resource correction, not a weakened semantic premise.
