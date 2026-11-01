# Source-derived cost boundaries

These are source observations and conditional complexity arguments, not new timings, total allocation counts or proofs about every possible Core architecture. The final campaign binds the actual source/binary versions.

| Work | Actual implementation | Necessity / scope |
|---|---|---|
| Complete normative Core record | Actual Core evaluation/commit constructs its existing record; both candidates retain it | Emitting B required bytes takes at least Ω(B) work. An unchanged record contract cannot remove that output cost. This does not prove that all current construction/copy/hash passes are necessary. |
| Research observation envelope | `ReferenceObservation` retains before/after state, evaluated record, committed record and commands | Larger than one Core decision record. These copies serve the declared complete-comparison claim; do not attribute all envelope bytes to Core's mandatory format. |
| Initial anchor | `Reference::new` admits the exact configured module and constructs the real Core genesis | Actual initialization, not an assumed free trusted snapshot. A persistent deployment could amortize it under separately established continuity/authorization premises. |
| Snapshot capture | `reference.rs` exports live state, rereads genesis and scans all records' `created` inventories for lifetime IDs | Complete for the declared ordinary segment but deliberately conservative. It visits live state plus historical records; cloning historical record objects can cost their full byte size, even though only created keys are retained. A future exact index must justify completeness and lineage, but repeated full scans are not a mathematical necessity. |
| A's J checks | Full derived meaning recomputed before/after update; prediction checked against actual Core | Checks the conservative mathematical pattern. It is not a measurement of unchecked incremental view maintenance and does not establish a lower bound on IVM. The prediction-only cost is not separately instrumented. |
| Prefix preparation | Forced reference executes prefix without exporting discarded snapshots; native A/B call complete observation-producing execution and discard prefix outputs | Same external measured suffix and real prefix transitions, different incidental work. Whole-run ratios are valid costs of these prototypes but do not isolate the effect of the validation algorithm. |
| B's initial version | Independent prefix reconstruction repeated for every witness | Avoidable repeated work identified during collection. Campaign001 is incomplete and retained; its numbers are not pooled with campaign002. |
| B's whole-history version | One new independent Store, prefix once, then full step recomputation and deep claim comparisons | Removes the repeated constructor/replay factor. It still pays snapshot/history capture, producer plus consumer and large comparisons. No producer approval or A state is trusted. |
| Deep equality | `ReferenceObservation::same_claim` clones both complete observations before normalizing availability metadata | A source-visible allocation/copy site; total copied bytes and allocator totals were not instrumented. Not necessary to the abstract equality theorem. |
| Study DAG | Recursively visits complete observations, hashes typed JSON nodes, shares equal objects and checks complete expansion | Storage sharing is real. Input traversal, SHA, flat array construction and full Core evidence remain work. It is not a persistent authenticated map updated only along changed paths, or a proof of query completeness. |
| Core029 reuse | Ordinary A/B Core calls can use existing Core incremental validation, while the forced reference disables it | A total difference from the forced reference is not attributable exclusively to newly implemented views. |
| Nova fixed circuit | Full bounded slots, live/used bits, five supported operations, range/selection constraints and SHA commitments | Actual constrained computation and cryptographic accumulation. Native capacities and wider native operations do not imply circuit support. |
| Existing identity bridge | Fresh consumer replays exact Core computation and compares full per-event outputs/identities | Mandatory for the current combined claim: Core MuHash/canonical history are not computed in the circuit. This prevents an end-to-end succinct Core-history claim, regardless of isolated folding verification cost. |

## Consequences for interpretation

A growth curve in this experiment can include Core evidence, wrapper state capture, history scans, J verification, transport, full export and independent checking. It must not be described as the intrinsic complexity of a global invariant, DBSP, witness checking or Nova.

The source permits concrete follow-up hypotheses: retain a complete lifetime-ID inventory from actual accepted Core deltas, avoid constructing discarded prefix observations, compare borrowed claim data, avoid duplicate canonical materialization and maintain persistent shared structures instead of rediscovering sharing from a complete JSON tree. None is an adopted optimization here. Each must preserve exact outcomes, selected errors, complete dependency coverage and canonical outputs where that profile remains unchanged.

For independent compact verification, representation identity alone is insufficient. A state hash does not establish complete query membership or absence; retained content does not establish authorization; a valid proof does not supply unavailable data. A future protocol needs explicit authenticated access/completeness, transition interpretation, version boundaries and recovery promises before combining persistent state, maintained views and accumulated proofs.

The evidence classes remain separate: checked logical theorems; structural template restrictions; actual finite Core/Rust/R1CS mutation tests; source-derived complexity; measured samples; and external/trusted premises. In particular, `bounded_step_exact` proves the logical checked-step relation. It is not a proof that the Rust R1CS generator implements that relation.


## Asynchronous progress interpretation

The frozen prototype's live field named `proved` advances after successful proof construction (`prove_step`). Fresh independent verification occurs at the end. A constructed fold is not itself an accepted certificate. During arrivals, the independently verified prefix is the previous checked checkpoint; only after final verification may the new endpoint be accepted. The final report is produced after that verification.

Retain the original counters, label their actual meaning and derive verification lag separately. `observed_max_pending` is a sampled construction/bridge backlog, not a proof of the maximum backlog or sustainable production throughput. The bounded two-actor fixture supplies known future inputs, uses already prepared parameters and shares one measured CPU. Its completed/drained rate and arrival-to-final-verification times are observations of that bounded experiment, not an unbounded steady-state guarantee.


A's disposable view publication is not a new durable Store transaction. Core commits remain authoritative. If a post-commit correspondence/view check fails, the view is invalid and the experiment reports a tool/integrity failure; it does not roll back Core or establish that no event committed. A future host integration must preserve explicit committed/unknown-acknowledgement outcomes at that boundary.

## Resource-censored native observations

The frozen collector applies the300s native cap to each whole native subprocess, including its initialization, real prefix preparation, measured operation sequence and output construction. It is not a separately restarted300s allowance for each individual transition. A timeout of that process does not establish that one creation takes300s, or identify the internal exhausted stage. The whole-case1800s bound additionally includes other required subprocesses and orchestration. Unfinished operation timings and bytes are unknown. Separate one-event cold-reconstruction cases remain differently scoped observations, not replacements for the eight-creation primary case.

## Full snapshot exports in this harness

Core's `Store::export_seed_at()` calls `versions_for()`. Even when semantic snapshot validation can reuse existing validity, that function enumerates the complete live key/version universe, decodes each entity, checks content identity, rebuilds the MuHash accumulator and compares StateId. Thus a snapshot export is not a cheap read of a cached root.

For a successful native baseline with H=8 and eight measured operations, the explicit wrapper-level `export_seed_at()` calls are source-derived as follows (not instrumented total Core call counts):

- Forced-reference helper: two per measured operation,16 total; discarded prefix observations are not exported.
- A: one initial view snapshot plus three per prefix/measured operation,49 total. `Maintained::execute()` captures its prestate and then `Reference::execute()` independently captures before/after again.
- B: two per operation in the producer and two again in the independent checker,64 total across both processes.

These counts exclude internal Core work and vary with the workload; they are not measured allocation/hash totals or a proof that exports dominate every sample. They identify a concrete redundant authentication/materialization boundary. Reusing an independently established exact-head snapshot or updating a complete lifetime inventory from accepted Core deltas is a follow-up hypothesis requiring explicit completeness, stability/concurrency and lineage premises. This finding does not justify skipping necessary Core integrity checks.

## Resource, storage and timing scopes

The primary native Store backend is in-memory. Its Core CAS/commit semantics are exercised, but its latency is not a production database or replicated durable-write measurement. JSON output and verified gzip research retention are separately observed work; including retention in the collector's contiguous total does not turn it into a Core persistence requirement. The public recovery/checkpoint cases have their own explicitly bounded filesystem durability scope.

RSS is measured per child;8GiB is an address-space limit for each child, not a measured bound on the whole controller, OS cache or full machine. Whole-controller peak memory and total allocations/copies/parses are unmeasured. DAG payload bytes omit the research transport envelope; actual raw/container file sizes are retained independently. Proof bytes are randomized transport artifacts, while the semantic claim identity excludes those bytes and all timings.

## Rule and query axes

R=1/4/16 repeats the cardinality invariant under distinct rule identities. These declarations can share an expression/query computation; the axis is not a benchmark of16 semantically independent global queries. The filter-term axis adds total positive-field conjuncts to `x < threshold`; the primary probes use threshold2 and positive x=1, so the added terms are active, but logically redundant under the fixture invariant. It characterizes this admitted expression/trace shape, not arbitrary predicate complexity. All three query-axis cases have eight creations **and eight probes**; compare them with each other, not the eight-operation no-probe baseline.
