# Core032 — verified incremental transitions

**Status: investigation complete; no production adoption authorized.** Measurements, scoped proofs, adversarial controls, all nine candidate/consumer dispositions and the unchanged repository gates are retained. Capacity failures remain explicit findings, not successful comparisons. The final evidence assessment checks completion separately from the mathematical claims.

## Exact claim and six independent boundaries

For the closed admitted module M, operational state Ω, operation/request I and supplied context C, the comparison concerns the complete result F(M,Ω,I,C): selected outcome/error, resulting operational state, exact history coordinates, canonical command occurrences and complete promised observations. Ω contains historical used identities and lineage as well as live values. Equal live content is insufficient.

Execution correctness, invariant preservation, historical identity, authorization/provenance, retained information and reconstruction availability are distinct claims. A proof of positivity/cardinality is not an exact-execution proof. A content hash is not a membership/completeness proof, authorization or data-availability guarantee.

The [transition contract](contracts/transition-contract.md), [evidence contract](contracts/proof-and-evidence.md), [trust ledger](evidence/correspondence.md) and [source-cost analysis](evidence/source-costs.md) define the interpretation.

## What was implemented

| Mechanism | Concrete supported claim | Scope and limits |
|---|---|---|
| Forced-full reference | Real Core Store evaluation/commit under the test-only full-reference selector, exact states/records/commands for the measured suffix | No new public production selector; actual route has an omission control. Prefix transitions execute and remain timed. |
| A — checked maintained views | Complete count/member/used-ID/reference/query views, independent closed-fragment prediction, full J checks, comparison to actual Core and complete checked view publication | Conservative co-checking prototype; full J/state/history capture and Core evidence remain. It does not measure an unchecked production IVM implementation. |
| B — independent witness checking | New independent Core Store per whole-history claim; exact prefix reconstruction, then every full before/after/result/command observation checked | Producer approval and A state are not trusted. Complete-snapshot/replay baseline, not a sparse authenticated witness protocol. |
| Shared DAG transport | Typed content-addressed nodes and roots with bounded hash-checked complete expansion | Actually transported, not just a size estimate. Full Core output is still constructed. Flat arrays and full traversal remain. No query completeness or availability follows from its root alone. |
| Nova accumulation | Real fixed-capacity five-operation R1CS, recursive proof, independently derived/validated parameters, exact expected initial/final state and step count, full Core bridge | C=1..16, lifetime catalog2C; no refs, batches, add/lazy or arbitrary Core IR. Compression not implemented. Core MuHash/canonical history are outside the circuit, so the combined verifier still needs full Core replay. |

The native template includes positivity, a genuine maximum count, references, lifetime identity, captured total queries, command multiplicity and error/lazy controls. The independent 1000/1001 boundary has explicit expected outcomes. Unsupported compositions fail closed rather than changing Core semantics.

## Mathematical evidence and its limits

The named Lean targets cover logical checker soundness/completeness and exact selected outcomes, view initialization/rebuild/complete-delta reasoning, conservative maintained checking, abstract observation expansion, digest-limb/range properties and sequential whole-history composition. Transitive axiom audit permits only `propext`, `Classical.choice`, `Quot.sound`; actual removed-premise/proof-integrity controls must fail. Fresh replay uses the same pinned Lean kernel in a new process, not an independently implemented kernel.

In particular, `bounded_step_exact` is a theorem about the logical checked-step relation. It is not a machine-extracted proof of the Rust R1CS generator or the Core interpreter. Rust/Core extraction, view/serializer/circuit/SHA correspondence, cryptographic libraries and the canonical renderer remain explicit trusted components, supported by structural inspection and finite negative/differential tests. Passing tests and a valid hash do not upgrade those boundaries to universally proved implementation correctness.

The accumulated certificate concerns one exact executed prefix. It is not a proof that every possible future action of an arbitrary module preserves every Safety Model policy. Valid genesis, migrations/module switches, approved deployment segments, trusted context and physical command execution remain separate obligations.

## Measurement interpretation

Final primary evidence is frozen in [campaign002](evidence/campaign-002/manifest.json). The matrix declares288 native attempts:16 deduplicated points × three strategies × two output profiles × three repetitions. Proof capacity varies C=1/4/16 and H=1/2/8; C1/H2 has three fresh first-use and three explicit reuse producer/consumer pairs. Those capacity cases start at N=0 and create one entity; C16 is allocated constrained capacity, not a populated16-entity benchmark.

Whole-case wall time includes actual required processes, parsing, full exactness comparison and verified retention. Process-only totals are summed inside each sample before computing a median. Phase medians are never summed into a cycle. Initialization, prefix preparation, operations, output, parameter derivation/loading, accumulation, verification and the Core bridge have different scopes. Unknown total allocation/copy/parse costs remain unknown; opt-in DAG JSON/SHA counters are not whole-Core allocator instrumentation.

The machine is a shared KVM x86_64 host with pinned CPU7 measurement/CPU0 orchestration, one worker and8GiB child address-space limits. Native/consumer phases have300s and proof production900s; the whole-case limit is1800s. OS file cache is not flushed. Resource exhaustion is a retained capacity result, never a semantic denial, failed safety theorem or accepted proof. Three repetitions do not establish production latency distributions or capacity guarantees.

The full research envelope contains state snapshots and both evaluated/committed records. Its expanded bytes are not the size of a single normative Core decision record. Existing required bytes impose Ω(B) output work; repeated copies, discarded prefix observations and repeated historical-ID scans are avoidable implementation work, not mathematical necessities. A/B may also use existing Core029 incremental paths, so a difference from the forced-full reference cannot be attributed exclusively to new views.

### Completed native results

All288 declared native attempts are retained:270 succeeded with exact claim agreement;18 exhausted the300s aggregate-subprocess limit at N8192. No unexplained mismatch or tool failure occurred. The exhausted cases do not yield completed-operation latency or output sizes.

Existing-profile contiguous collector medians, seconds, three repetitions per cell:

| Initial E population, H=8 | Forced-full reference | A | B producer plus independent checker |
|---:|---:|---:|---:|
|128|7.409|10.592|17.466|
|512|33.800|48.653|78.928|
|2048|151.499|211.554|363.098|
|8192|unfinished|unfinished|unfinished|

At fixed N128, the H=8/32/128 medians are respectively7.409/13.916/43.685 for the reference,10.592/26.873/125.003 for A and17.466/44.773/192.938 for B. These are costs of the stated complete prototype workflows, including real prefix preparation and research retention. They are not isolated validation-function timings, production steady-state latency or intrinsic lower bounds on maintained views/witness checking.

Actual A transport-file medians distinguish representation from compression:

| N | Existing raw bytes | Study raw bytes | Existing gzip bytes | Study gzip bytes |
|---:|---:|---:|---:|---:|
|128|1356213|859513|58783|289508|
|512|5174712|2959995|212977|1330716|
|2048|20566100|11362992|720418|5088370|

The shared DAG reduces raw payload but its compressed standalone packet is larger. This is an observed disadvantage of this JSON-node/full-support encoding, not evidence against all content-addressed or persistent structures. Warm incremental support exchange and different object granularity were not measured. Do not use raw size alone to recommend this format. All per-point/profile samples and failures remain in the native index.

### Protocol history

- Early001 proofs remain valid, but controller affinity was not actually enforced. Their timings are excluded; [the annotation](evidence/proof-smoke/early-001-protocol-annotation.json) and original artifacts remain unchanged.
- Corrected Early002 applies and records the intended affinities; three first-use and three reuse pairs actually verify and match the Core bridge.
- Campaign001 repeated prefix reconstruction per witness. It is retained as incomplete, with [an amendment](evidence/campaign-001/amendment.json). Campaign002 freezes the independent whole-history B refinement; old and new measurements must not be pooled.
- [Cold reconstruction](evidence/cold-recovery-001/protocol.json) separately freezes N128/N8192 with one command-only anchor. This does not replace an unavailable eight-creation primary anchor. Original outcomes and the separate actual reconstruction result remain visible.

## Proof lifecycle and independent consumers

First-use independently derives parameters inside both producer and consumer budgets. Reuse validates exact consumer-derived parameter artifacts and still checks every new proof. A producer-selected key or prior acceptance cannot replace the checks. Actual wrapper controls include altered subjects/endpoints/outputs and cryptographically valid proofs presented under an incorrect claim.

Checkpoint continuation checks the complete previous claim before extending it. Partial or interrupted create-only publication cannot become a valid checkpoint. This cooperating local-filesystem experiment is not a universal power-loss guarantee.

The bounded asynchronous fixture records native, folded and bridged progress. Its raw field named `proved` advances after construction; the independently accepted prefix remains the previous verified checkpoint until final verification succeeds. Report verification lag separately from sampled fold backlog. A two-actor bounded drain with known future inputs and prepared parameters is not an unbounded sustainable-throughput claim.

The independent public `behavior-engine` consumer exercises persisted-before-acknowledgement recovery, original-event retry, stale conflict, duplicate canonical command occurrences, paging, replay and missing historical support. Proof/checkpoint artifacts add no Core business state or replay dependency. The portable packet supplies data to independently selected trusted tools; it grants no authority to execute producer-supplied code.

## Candidate and consumer dispositions

The machine-readable decisions are in [dispositions.json](evidence/dispositions.json). These concern the actual bounded prototypes; none authorizes production adoption.

| Candidate | Local execution | Independent checking | Succinct Core history |
|---|---|---|---|
|A, checked maintained views|Further research|Reference only|No-go|
|B, whole-history witness checker|No-go as a local optimizer|Further research as an exact baseline|No-go|
|Nova accumulation|No-go as a local execution optimizer|Further bounded research|Defer|

A establishes a checked maintained-meaning pattern but still pays full J/Core/snapshot costs. B establishes an independent exact checking boundary but recomputes the claimed history. Nova actually accumulates and verifies the bounded computation, yet the current exact Core claim still needs a full bridge. Thus no measured prototype solves all three consumer goals. The results do not select a hybrid or refute maintained views, authenticated structures or accumulation in general.

The current JSON-DAG/full-support codec is also unsuitable as a compressed cold storage/transport optimization in these cases: its gzip packets are larger and full expansion/construction remain work. A persistent authenticated structure or different granularity is a different experiment.

## Accumulated proof and recovery results

All nine declared C/H points verify and match the expected Core claim. Eleven first-use pairs include three C1/H2 repetitions; the original three reuse pairs also verify. A separately frozen three-pair reuse supplementation measures actual contiguous totals omitted by the old sampler. Its data is retained separately rather than pooled or reconstructed from phase medians.

At C1/H2, first-use producer-plus-consumer contiguous median is68.818s; the separate reuse median is22.487s. First-use parameter preparation is about32.7s per process; timed reuse loading/decoding/validation is about9.6s per process. Median isolated verification is1.226s versus1.243s in the two modes, and the small consumer Core bridge is about0.056s. These are separately measured scopes, not additive median components. The raw recursive proof is5385450 bytes. IPA/Spartan types supply setup floor hints; no cryptographic compressed proof is produced or verified.

The three fixed-C1 H=1/2/8 verification times are0.472/1.226/2.249s. Constant proof byte size does not establish constant measured latency. The limited H/C ranges, capacity padding and instance-dependent implementation work do not justify an asymptotic timing claim. The linear/full Core bridge remains a separate obstacle to end-to-end succinct verification. See the complete [cost model](evidence/cost-model.md) and [derived lifecycle data](evidence/lifecycle-costs.json).

Actual fresh one-event cold reconstruction and J rebuild take0.526s at N128 and37.763s at N8192. These use independently frozen H1 anchors; the unavailable N8192/H16 primary anchor remains `NotProduced` in the original report. Both facts are preserved by [recovery validation](evidence/recovery-validation.json). The full smaller-prefix recovery, public lost-ack/conflict/command-paging/replay controls, invalid-proof wrapper controls and real checkpoint continuation pass. Losing proof/view artifacts does not introduce a Core replay dependency.

The asynchronous fixture begins at verified head2 and ends with verified/native/bridged head4 and no pending work. Its two arrivals wait4.600s and4.546s for final verification, over a6.087s bounded run with prepared parameters. Raw `proved` progress means constructed folds, not interim certificate acceptance. These finite observations do not establish sustainable production throughput.

The separate DAG diagnostic preserves exact observations and records97980 JSON Vec/SHA calls over11898572 bytes at the named experimental sites. Whole-Core/Nova allocation/copy/parse totals and controller peak memory are unmeasured. Per-child peak RSS, raw/container sizes, independent-axis growth and nested reference timings are retained in the derived data; a source-visible expensive site is not automatically a measured percentage of total CPU.

## Compatibility and test-wiring correction

No Core execution semantics, published record/hash/receipt, established fixture or historical Core031 archive is changed. The existing runtime-source addition is a `cfg(test)` module declaration. The first unchanged workspace gate found duplicate loading of the established workload fixture. The correction shares that existing test module: one test-only visibility change and explicit imports in the new adapters, with no fixture-content or assertion change.

[The exact patch and before/after hashes](evidence/test-wiring-amendment.json) retain this post-collection test-wiring amendment. The original frozen primary sources/binaries and their measurements are unchanged; no new performance claim is made for a changed libtest layout. The initial failed gate/audit remain in `evidence/gates/` and `evidence/compatibility.json`; the final unchanged gate rerun and exact inverse-overlay audit are recorded separately.

## Adoption requirements and remaining limitations

1. First investigate avoidable byte-preserving work: redundant exact-head snapshot exports, discarded prefix observations, repeated lifetime-ID reconstruction, deep copies and repeated canonical materialization. A cache/index needs complete initialization, exact history/module/context coordinates, sound updates, stable authenticated input and correct failure handling. Skipping necessary checks is not an acceptable optimization.
2. An efficient maintained-view implementation needs a reviewed/checked delta/dependency correspondence, preserving partial expressions, checked arithmetic, selected errors and complete effects. The present conservative co-checker does not establish that result or its performance.
3. A sparse untrusted witness needs authenticated state access and query/absence/completeness premises. A hash of a state or evidence file supplies identity, not those premises or data availability.
4. Succinct Core verification needs the exact identity/observation bridge proved or checked cheaply under an explicit contract. Replacing eager full evidence with retained support/root/deltas requires a versioned interpretation/reconstruction contract; a lossless transport codec alone can preserve old record bytes but cannot remove their construction work. Existing published artifacts keep their original meanings and verifier requirements.
5. The Rust/Core/model/R1CS/serializer/crypto correspondence boundaries remain trusted, not silently kernel-proved. Valid initialization, migrations, exact-head module/policy activation, approved-module enforcement, trusted context, retention and physical execution remain external/separate.
6. Performance applies only to the recorded shared x86_64 environment and closed workloads. R repeats one invariant expression; query terms are active but redundant total conjuncts. Capacity C is not populated state or unlimited lifetime identity. No arbitrary-Core, external-application, cross-machine bit-identical-build or production durability guarantee follows.

No new Safety Model family, Core primitive, governance policy, persistent application state, runtime proof requirement, release process or production adoption was introduced. The next work should be selected from these specific remaining obligations and measured avoidable costs; optional architectural breadth is not an automatic task.

## Completion evidence

The unchanged [repository gates](evidence/gates-002/report.json) pass, including determinism, replay and external-consumer checks. The [exact compatibility audit](evidence/compatibility-final.json) reports no unexpected tracked changes and no changes to the 1684 protected files. The original failed gate is retained alongside the exact test-import repair. All eight [final scoped checks](evidence/final-checks/report.json) pass.

The final [evidence assessment](evidence/assessment.json) checks FR-001–018 and SC-001–006, retained artifact identities, source/proof correspondence inventories and complete attempt coverage. The [completion index](evidence/completion.json) binds the four story reports, campaign, proof/recovery/portable results, cost model, nine dispositions and validation reports. These are research-completion records, not a new execution or Safety Certificate. No commit, push, tag, release or experimental production adoption is part of this work.
