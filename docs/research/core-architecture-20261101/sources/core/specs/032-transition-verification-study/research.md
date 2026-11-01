# Planning research: Core 032

**Date**: 2026-10-28. These are design decisions, not new benchmark results. The preceding [first-principles analysis](../031-scalable-execution-evidence/profiling/first-principles-20261028/research.md) and [IVC research](../031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md) retain their original scope and qualifications.

## 1. Compare different correctness/reuse mechanisms

**Decision**: Implement A, maintained exact views with initialization/update/recovery relation J; and B, independent checking of complete-snapshot transition witnesses. B binds its full state and lifetime-ID inventory to an independently accepted anchor, rather than trusting A's summaries or a producer completeness label.

**Rationale**: A justifies retained meaning inductively; B checks an individual claimed computation from untrusted support. Full snapshots avoid presupposing an authenticated query-completeness system. B may honestly remain linear; all output/recovery costs remain measured.

**Alternatives considered**: Verified incremental compilation/cache-transfer style is credible, but implementing a compiler and Core partial-expression correspondence exceeds the smallest comparison. Sparse authenticated witnesses require additional absence/summary/completeness obligations and remain a follow-up candidate.

**Executable B refinement**: The first implementation rebuilds the exact Core anchor from the closed genesis recipe and complete ordinary operation prefix before comparing the full snapshot and recomputing the proposed step. This includes existing Core history/bundle metadata without inventing a new snapshot-import authority or trusting a producer's endpoint. It can cost O(history plus replayed state/evidence), exceeding a standalone O(N) snapshot check; report this initialization/replay cost per check. A future cheaper checker must justify the same anchor/metadata correspondence. This conservative baseline is not evidence of an efficient transition checker.

**Verified precedents and limits**: [CompCert's validator](https://compcert.org/doc/html/compcert.backend.Allocation.html) and [proof](https://compcert.org/doc/html/compcert.backend.Allocproof.html) concern accepted compiler-pass transformations, not Core transitions. [Incremental lambda calculus](https://inc-lc.github.io/) establishes change transformations under its language/primitive premises. [Certifying computations](https://people.mpi-inf.mpg.de/~mehlhorn/ftp/VerificationCertComps.pdf) separates witness soundness and representation/implementation correctness. [VerDILog's development](https://raw.githubusercontent.com/VerDILog/VerDILog/iclp-2018/vup.v) flags axioms and a theorem-strengthening issue; rule-program satisfaction is not exact result equality. None automatically verifies Core.

## 2. Machine-check the restricted exact contract

**Decision**: Lean 4.30.0 without mathlib, from existing nixpkgs lock `6774f7bc253789b113a4f39285dc0fa100abeacc`. Read-only evaluation resolved derivation `/nix/store/6wy0z2zc7gl2i6vxzcw59i9pdhk2g6b8-lean4-4.30.0.drv`; the already installed binary reports 4.30.0. Package source v4.30.0 has hash `sha256-YTsfIppd6km7wOjAxRH5KMPsW++ztFDCJT2up72J86Q=`. Add Lean to an isolated study environment; the current default shell does not include it.

**Rationale**: Reuse the actual lock. Prove F/J/K, supported-outcome completeness and history composition for the declared model. Audit transitive axioms, independently replay declarations with `leanchecker --fresh`, and retain statements/artifacts. The locked package includes `leanchecker`; proof replay remains implementation work. Follow [versioned proof-validation guidance](https://lean-lang.org/doc/reference/4.30.0/ValidatingProofs/). In particular, fixed-width wrapping arithmetic must not substitute for Core checked overflow.

**Alternatives considered**: Coq/Agda are established tools, but importing their unrelated theorems does not remove Core correspondence work. Full verified extraction/Core implementation verification is a different project. Differential tests support the reviewed adapter, not a universal proof.

## 3. Nova: early executable proof with a complete statement

**Decision**: Pin [Nova](https://github.com/microsoft/Nova/tree/01b1e2d662a847ed7029770ecbaf6687398899dd), commit `01b1e2d662a847ed7029770ecbaf6687398899dd` (2026-09-11), package 0.76.0, MSRV 1.88.0. Core's Rust 1.98.1 meets the declared minimum; actual compilation remains an implementation check. Use `PallasEngine`/`VestaEngine`, Pedersen commitments, `provider::ipa_pc::EvaluationEngine` and `spartan::snark::RelaxedR1CSSNARK`. Disable default features and commit the isolated Cargo lock.

**Rationale**: The [StepCircuit API](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/traits/circuit.rs) can express bounded full execution/checking. Carry complete fixed-capacity state and used-ID bits; keep circuit shape independent of witness values. This avoids assuming authenticated RAM. SHA chaining binds outputs only after constraints establish their meaning. A proof of positivity alone is insufficient.

**Lifecycle**: Prepare public parameters with the selected compressor's `ck_floor()` hints. `RecursiveSNARK::new` synthesizes the first step; `prove_step` must count each step, including the first. Measure compression separately. Independent `verify` returns a final state, which the wrapper must compare with its expected endpoint/output. Do not accept an arbitrary producer verification key. See [implementation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/nova/mod.rs).

**Integrity**: Use two range-constrained 128-bit limbs or 256 Boolean wires for SHA-256 identity, not one reduced Pasta scalar. Freeze tags, lengths, padding and endian conventions. Keep logical attempts distinct from committed position and circuit microsteps. Command-only commits advance history; refusals do not. Record proof randomness separately from deterministic claim identity.

**Alternatives considered**: The pinned MinRoot example uses KZG; copy lifecycle patterns, not its backend. Pallas/Vesta [Pedersen setup](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/provider/pedersen.rs) avoids a trusted SRS baseline. zkVMs or newer folding systems may be explicit comparators, never an unexplained Nova replacement. External paper timings are not our measurements.

## 4. Core identity requires an explicit bridge

**Decision**: Separate the study semantic/history commitment from Core StateId/StoreId/record-chain identity. A combined consumer independently reconstructs/checks the existing-profile bridge from retained support. Acceptance requires both semantic proof and exact identity/output agreement. Measure parsing, rendering, hashing and transfer of that bridge.

**Rationale**: [Core persistence](../../docs/persistence.md) separates MuHash3072 content identity and exact history identity. A generic root cannot replace them. A complete bridge can remain linear in history/evidence, preventing a whole-Core succinctness claim even when folding verification is history-independent.

**Alternatives considered**: Circuit evaluation of every existing canonical record/MuHash operation could be an extension, not an assumed cheap primitive. A future commitment needs a versioned contract. Merely carrying unconstrained Core IDs is rejected.

## 5. Preserve actual commands and errors

**Decision**: Preserve canonical intent occurrence order/multiplicity and inter-event history order, not authored emission order or physical dispatch sequencing. Include selected-error order, checked arithmetic and lazy branches in supported scope; outside it return experimental Unsupported or exact reference fallback.

**Rationale**: [Commands](../../docs/commands.md) are bags of intents; equal payloads remain separate occurrences. Equal live content does not imply equal command history. Comparing only ALLOW/DENY or final StateId loses required meaning.

**Alternatives considered**: Failed witness checking is a verifier result, not a business denial. Hashing a producer's output does not establish exact execution.

## 6. Freeze capacity and decision policy

**Decision**: CPU-7/CPU-0, 8 GiB per child, 300 s native/consumer and 900 s proof-history bounds; three repetitions per primary point. Independent native N/H projections; small proof circuit capacities C=1/4/16 and H=1/2/8. At least one accumulated proof must verify. Details in [experiment protocol](contracts/experiment-protocol.md).

**Rationale**: These are research resource ceilings, not product promises. Assess whole lifecycle work, amortization and uncertainty for each consumer. No mandatory numerical speedup is invented. Timeouts remain explicit capacity results.

**Timing clarification**: Freeze parameter recipes before measurement, not a hidden cache for first-use runs. Measure first-use producer/consumer parameter derivation inside their respective 900 s/300 s totals, then separately measure reuse with timed artifact loading/validation. The early US3 proof run owns a minimal freezer and manifest independent of US4; the final campaign freezes a new subject. Recovery measurements consume an independent public-consumer test written and made green earlier in US3.

**Alternatives considered**: Unlimited retries, favorable repetition selection and silent budget increases invalidate comparisons. Requiring immediate circuit support for N=8192 would expand the bounded feasibility study into a production proof-engine project; large native scaling remains mandatory.

## Resolution

No planning clarification remains. Implementation correctness, circuit feasibility, scaling and candidate dispositions are experimental deliverables, not assumed conclusions. No production architecture or hybrid is selected.

## Platform finding during implementation

**Observation**: The pinned upstream x86_64 Nova configuration compiles, but `nova_cpu_probe 3` exits 132/SIGILL on the declared CPU. Nova requests halo2curves 0.9.0's asm feature; halo2derive 0.2.0 emits MULX/ADCX/ADOX without runtime dispatch. This is an environment/tool failure, not a mathematical counterexample or a completed proof attempt.

**Decision**: Use an explicitly identified Cargo-only portability overlay selecting halo2curves' existing Rust arithmetic. Preserve the full upstream source inventory and patch digest; all Rust source bytes remain unchanged. The dependency's implementation is still trusted and unverified. Do not describe this as an unmodified-default Nova measurement, reuse pre-overlay parameter acceptance, or change Core or Lean's axiom contract. Validate the real field operation and circuit tests under the portable configuration before proof production.

**Alternative**: Require another CPU with ADX/BMI2, which would change the reference platform. A routine source-configuration overlay is smaller and reproducible on the already declared platform; no cryptographic algorithm rewrite is justified.


## Executable investigation findings (2026-10-29)

The following findings refine the implementation, not Core semantics or the declared comparison language. Final numerical conclusions depend on the retained comparative campaign.

- **Exact checking is a mechanism, not automatically a shortcut.** B's accepted claim is the complete output sequence. Reconstructing genesis and prefix independently for each witness repeated work. The whole-history checker reconstructs once in a fresh Store, then recomputes and compares every step. Its correctness follows the checked sequential-composition pattern; it does not trust producer approval, reuse A's views or retain cross-invocation state. The original campaign is preserved as incomplete and the replacement is separately frozen.
- **A is deliberately conservative.** Its Rust implementation maintains counts, members, incoming-reference and captured-query views, but checks the complete J relation and compares against actual Core before publishing. The Lean maintained theorem proves correctness of that checked pattern, not the correctness or asymptotic cost of an unchecked incremental optimizer. A also uses Core's existing incremental execution where eligible; differences from a forced-full reference cannot be attributed exclusively to the new views.
- **Transport sharing and semantic execution are different costs.** The actual shared JSON DAG can retain complete expansion while deduplicating repeated nodes. It still constructs Core's complete evidence, visits arrays and validates support. Its abstract interpretation theorem does not prove the Rust encoder or establish non-membership/query completeness from a hash.
- **A real Nova proof is narrower than Core execution.** The implemented fixed-capacity circuit covers create/literal assignment/remove/emit/threshold query with historical used-ID bits, checked ranges, commands, all output digest bits and attempt/commit counts. References, checked-add/lazy controls and simultaneous batches are native-only. The exact admitted Core identity is independently established by a full per-event Core bridge. No arbitrary Core circuit, Core MuHash circuit, compressed proof, succinct combined verification or production deployment guarantee is claimed.
- **Proof integrity is scoped.** Structured transitive axiom audit permits only `propext`, `Classical.choice`, `Quot.sound`; actual missing-premise and proof-hole controls fail. Fresh `leanchecker --fresh` replay uses a new process with the same pinned Lean implementation. Rust extraction/renderer/DAG/R1CS/SHA/crypto correspondence remains an explicit trusted boundary.
- **Timing protocol corrections are retained.** Early001 proofs remain valid, but their controller was not actually pinned to CPU0; they are excluded from binding performance conclusions. Early002 applies and records CPU0 orchestration / CPU7 measurement. The optimized final source also emits only the requested suffix on both comparison sides while still performing and timing real prefix preparation. Original artifacts were not rewritten.

The study runs on a shared host with pinned process affinity, not an exclusively reserved machine. Frozen hardware/process snapshots and individual process/resource records bound the interpretation of timing comparisons; three repetitions do not establish a latency distribution or production capacity guarantee.

### Interpretation of implementation costs

The mechanisms promise the same complete measured suffix, but their internal preparation is not identical. The forced-reference adapter executes the real prefix without exporting discarded prefix snapshots. Native A/B currently call their complete observation-producing executor during prefix preparation and discard those outputs afterward. This is avoidable prototype work, not a semantic requirement or a mathematical lower bound. A's full J checks, B's deep claim comparisons and repeated live/history capture are also implementation costs. Phase records make initialization, preparation and measured operations visible; whole-run ratios cannot isolate the cost of a view algorithm or a validation rule.

Similarly, the full research observation envelope includes before/after snapshots and both evaluation and committed-record data. Its expanded size is not the size of one normative Core decision record. A required output of B bytes imposes at least Ω(B) emission work for that output contract, but optional envelope copies and eager full-audit construction are not therefore mathematically necessary. The dossier must distinguish these scopes.

Cold view reconstruction has a separately frozen protocol in `evidence/cold-recovery-001/`: N128 and N8192, each with one command-only anchor. It measures full authoritative reconstruction and J rebuild independently of whether the eight-creation primary case finishes. It cannot substitute for, repair or hide a failed primary sample; the original native/recovery outcomes remain retained. The post-campaign checker records both reports and treats tool failures differently from a documented unavailable primary anchor caused by resource exhaustion.


### Proof capacity versus populated state

The frozen capacity cases start at N=0, create one entity, then use command-only commits to reach H=1/2/8. C=1/4/16 changes the fixed constrained capacity and its 2C lifetime catalog; it is not a claim that 16 live entities were populated in the C16 timing case. Actual N, logical attempts, commits, command occurrences and microsteps remain separate coordinates. Additional R1CS controls exercise supported assignments/queries and invalid state transitions; the retained real remove/reused-ID proof is a separate correctness control. Do not describe the capacity matrix as a benchmark of every supported operation or of a populated C16 application.

### Contiguous reuse measurement supplementation

The original early/reuse sampler retained actual producer/consumer process intervals but omitted a per-pair contiguous whole interval. Those process metrics and successful proof checks remain valid; the missing whole metric must not be reconstructed by summing phase medians. The comparative first-use capacity collector already records a real contiguous total.

`benchmarks/timed_reuse.py` therefore declares a separately frozen three-pair reuse group after the final independently derived parameter artifacts exist. It preserves the original reuse records, exact tool/case/parameter identities, source archive and limits; it adds a measured start-to-acceptance/integrity interval and is not pooled with the original phase-only timings. No Core/circuit semantics or resource budget changes. The final cost analysis uses the new group for contiguous reuse totals and keeps the original groups as qualified phase/feasibility evidence.


### Final test-wiring repair

The full unchanged workspace gate detected `clippy::duplicate_mod`: the new libtests loaded the existing031 workload/fixture a second time in the same crate. The exact post-collection repair widens that test module only to its parent and reuses it via aliases; integration crates each declare it once. Fixture contents, assertions, runtime behavior and all frozen primary archives/binaries remain unchanged. The patch and before/after hashes are retained in `evidence/test-wiring-amendment.*`; the first failed gate/audit are preserved and the unchanged gate is rerun separately. The final source audit admits only those exact test-file hashes, and the tracked baseline audit inverses the one visibility edit byte-for-byte.
