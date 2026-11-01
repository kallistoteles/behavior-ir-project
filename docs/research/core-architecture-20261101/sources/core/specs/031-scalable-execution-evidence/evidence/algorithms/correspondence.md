# Query maintenance: mathematical and Core correspondence assessment

Evidence class: written conditional argument and source inspection. This is not a new Lean proof, a verified Rust extractor, or authorization for a production optimization.

## Finite-state argument

Represent one entity type by a finite partial map `S : TypedEntityIdentity ⇀ Value`. A simultaneous delta is a partial map `D : Identity ⇀ (before?, after?)`, with at most one entry per identity. Require that every before value agrees with S, every creation has no live before value and a previously unused identity, every removal exists, and every actual change is included. Unchanged identities may be present as no-op entries. The new state replaces exactly these entries. Aliased bindings must be resolved to identities before constructing D; two parameter names are not two entities.

For a total pure predicate p with fixed typed captures k, let `m(v)=1` when p(v,k) and zero otherwise; missing values contribute zero. Split the finite domain into changed and unchanged identities. The unchanged summands cancel, so

`count_p(S') = count_p(S) + Σ_D (m(after) − m(before))`.

This proves the formula for arbitrary finite maps under those premises; it does not prove extraction completeness or Core-observation equivalence. Existence follows from `count_p > 0`, provided evaluating the complete predicate cannot produce another observable error. A frequency map of typed keys similarly maintains selected uniqueness: unique iff every frequency is at most one. The key type must preserve Core equality, including `None == None`, entity-type distinctions, enum type, and numeric semantics. A lossy string key is insufficient.

For a total integer projection, the analogous sum identity holds over mathematical integers. Core uses checked arithmetic in canonical query order. Equality of the final mathematical sum alone does **not** establish equality of intermediate overflow or the selected error. A sufficient restricted fragment is nonnegative values with an established upper bound on the complete sum, plus total projection and unchanged captures. Signed sums with cancellation require an additional order/prefix argument or ordinary recomputation.

## Mandatory correspondence obligations

| Mathematical object/premise | Actual Core source or observation | Failure/fallback |
|---|---|---|
| Exact state S | Validated Store parent, schema, StateId **and history reference** | Same StateId at a different position does not establish identical authority/history |
| Complete D | Simultaneous resolved resulting effects, creation/removal and all aliases | Unknown mutation or dependency means affected; never assume absent |
| Fixed p and captures | Admitted typed expression and bound entity/input/context values | Different capture invalidates summary even if no queried entity changed |
| Total, pure p | Evaluation defined for every admitted relevant value, including lazy branches | Partial division/unwrap/erroring branches require full ordered evaluation |
| Exact count/frequencies | Initialization from complete validated state; identities and multiplicities preserved | Duplicate/stale delta or reused removed identity rejects experiment/falls back |
| Core result | Rule truth, selected refusal/error, traces, query membership and observations | Value-only equality is insufficient |
| Trusted reuse | Same admitted module, profiles, policy, parent and dependency certificate | Missing edge or cache loss rebuilds from authoritative inputs |

Core's canonical query order, lazy Boolean evaluation, rule order and observed members are part of the obligation. An existence implementation that stops at the first true row can differ from a query pipeline that evaluates a later erroring predicate. Likewise, an immutable Ref requires target existence; maintaining a numeric count does not establish complete reverse-reference absence. Initializing a summary costs at least the inspected input size; updating it may cost O(D) or O(D log N), but required O(B) output and independent replay are additional costs.

## Candidate comparison

| Candidate | Exact useful fragment | Additional burden | Assessment boundary |
|---|---|---|---|
| Specialized count/frequency summaries | Total local predicates/projections, fixed captures, complete typed delta | Initialization, invalidation, exact observation synthesis | Smallest candidate for a separate implementation proposal |
| DBSP-style signed typed deltas | Finite multiplicities, group-valued mathematical views | Core checked/partial values are not a group; ordered traces need separate correspondence | Strong algebraic reference; not a drop-in semantic theorem |
| Differential dataflow | Multiple incremental operators and dependencies over partially ordered times | Map Store's linear history and retries without changing occurrence semantics; maintained state/output costs | More machinery than the first restricted fragment needs |
| Adapton-style dependency invalidation | Demand/reuse with complete dependency edges and exact names/captures | Mutation/exception/order correspondence; unknown dependencies invalidate | Useful design discipline, not evidence that Rust Core is verified |

Sources and exact inspected artifacts are indexed in [sources.json](sources.json). Their theorem scope is qualified in [proof-scope.md](proof-scope.md). No source-only formalization is used as independently kernel-checked acceptance evidence. The public Core transition oracle and bounded research experiments, when run, remain implementation tests under this written argument.

## Current Core reuse and limits

Core already has test-only replacement-delta/composition/operator controls in `crates/behavior-core/src/incremental_proof/`, and checked prepared-state/template reuse. Those are existing Rust tests, not an external Lean theorem or a new runtime engine. The finite-map helper here is one fixed entity type and returns a mathematical count; Core checked-Int representability and exact observation synthesis remain separate integration obligations.

Core `any(select, body)` short-circuits its body in canonical order, while `any(where(select, partial), true)` first evaluates the filter pipeline. The native oracle distinguishes their defined/error results. Wire 0.7 error wrapping is retained exactly. Differential time compaction also needs a separate Core boundary: a frontier theorem for future queries does not authorize dropping history still addressable by existing historical APIs.
