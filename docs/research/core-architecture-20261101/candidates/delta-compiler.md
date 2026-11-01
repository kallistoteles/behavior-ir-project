# Alternative 2: a proof-preserving delta compiler

2026-11-01. **Design proposal, with a written aggregate law; no implementation, machine-checked Core theorem or new timing result.** The design deliberately puts the principal seam at **module admission and compilation**. An application installs a certified incremental program and executes it. It does not author an execution witness for every request, and it does not choose among a small fixed collection of semantic-kernel operations. A compiler derives and composes change programs for the admitted expression language; extensions add certified primitives and compiler rewrites. This buys extensibility at a substantial compiler-correspondence cost.

The useful hypothesis is that module-specific computation and observation maintenance can become executable derived programs, proved once, rather than full-state co-checks performed after every operation. Independent history verification additionally needs an accumulated proof of those programs' exact execution. Compilation alone cannot provide that guarantee. This document connects initialization, updates and independent consumption through one proposed relation and charges proof production, preparation, storage and reconstruction explicitly.

## Review coverage and what is different

The [13-study inventory](../../investigation-map.md) is the coverage register. Original Core sources below mean the retained checkout `/tmp/behavior-ir-core-final-20261031`, not a moving branch. These studies establish the problem and existing limits; none validates this proposed compiler.

| Inventory entry | Material reviewed | Consequence for this alternative |
|---|---|---|
| 1. Core029 | [Evaluation report](../sources/core/specs/029-incremental-global-validation/evaluation-report.md), [conditional correctness](../sources/core/specs/029-incremental-global-validation/correctness.md), [supported interface](../sources/core/docs/incremental-validation.md) | Existing local/count reuse is real, narrow, history-bound and still emits complete evidence. Generalizing its Boolean certificate is insufficient. |
| 2. Core031 | [Investigation](../sources/core/specs/031-scalable-execution-evidence/investigation.md), [algorithm correspondence](../sources/core/specs/031-scalable-execution-evidence/evidence/algorithms/correspondence.md), [external proof scope](../sources/core/specs/031-scalable-execution-evidence/evidence/algorithms/proof-scope.md) | Complete typed deltas, fixed captures, totality, exact errors and observations are separate obligations. The finite-map helper's full check remains linear. |
| 3. Single creation | [Profile](../sources/core/specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md) | At N8192, 4,085,191 decision bytes and roughly 79% trace persist despite few predicate evaluations. Changing the normal evidence representation is necessary to remove this growth. |
| 4. Architecture and authenticated structures | [Options](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/architecture-options.md), [structure review](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/authenticated-structures.md) | Typed caches, persistent sequences, authenticated maps/ranges and crash-safe publication solve different problems. A DAG alone supplies no semantic coverage. |
| 5. First principles | [Research](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md), [derived alternatives](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/derived-architectures.md), [obligations](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/obligations-and-limits.md) | Ω includes lifetime identity use and exact history; exact execution is stronger than invariant preservation. Incremental compilation was already an independent route. |
| 6. Greenfield/IVC | [Research](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md), [IVC findings](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/ivc-findings.md), [composition](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md) | Keep native execution, accumulated proof and available audit support distinct; include initial memory, hash/identity bridge and proof closure. |
| 7. Core032 | [Research/deferral](../sources/core/specs/032-transition-verification-study/research.md), [investigation](../sources/core/specs/032-transition-verification-study/investigation.md), [source costs](../sources/core/specs/032-transition-verification-study/evidence/source-costs.md), [contract](../sources/core/specs/032-transition-verification-study/contracts/transition-contract.md), [correspondence](../sources/core/specs/032-transition-verification-study/evidence/correspondence.md) | A rechecked full J/Core; B replayed exact history; the DAG started with full output; the circuit omitted the exact Core identity bridge. Verified incremental compilation and sparse witnesses were explicitly deferred. Their poor prototype totals do not refute this alternative. |
| 8–9. Decode/typed reuse | [Strict decoding](../../core-continuation-20261029/report.md), [typed materialization](../../core-typed-record-20261031/report.md) | Preserve lexical/typed error precedence and array-shaped trace compatibility for old readers. These remove repeated work without changing the evidence contract. |
| 10–11. Residual/ownership | [Residual profile](../../core-residual-profile-20261031/report.md), [bundle ownership](../../core-bundle-ownership-20261031/report.md) | Allocation history and ownership affect constants; a removed clone does not establish changed complexity. |
| 12. Final compatible optimization | [Final report](../../core-final-investigation-20261031/report.md) | Its measured 22–31% consumer improvement and small command-v2 serialization regression remain evidence about the old representation. Repeating its streaming/borrowed-view patch is outside this design. |
| 13. Reassessment | [Scope](../../core-redesign-reassessment-20261101/scope.md), [prior evidence](../../core-redesign-reassessment-20261101/prior-design-evidence.md), [pinned research](../../core-redesign-reassessment-20261101/researched-alternatives.md) | All three stages must compose; a proof sidecar with replay outside it fails the desired independent-history claim. |

The design follows the **Module / Interface / Implementation / Seam / Adapter** vocabulary in [Codebase Design](/home/kalle/.codex/plugins/cache/mattpocock/mattpocock-skills/1.3.2/skills/engineering/codebase-design/SKILL.md). Its module is deep only if changing an index or a correct derivative does not change application code or independent-history claims. Complexity moves into one implementation, but the cost of that complexity remains in the interface's admission, resource and recovery contract.

## The exact subject

Fix a fully admitted Core module M, its complete metadata relevant to observations, semantic/evidence profiles P and original contextual input I. Define

`Ω = (live typed values, lifetime-used typed IDs, exact lineage/history, module/schema/profile/policy facts)`

and `F(M,P,Ω,I) = (outcome, candidate Ω, canonical command occurrences, selected error, normative observations)`.

The function includes binding/type/lifecycle errors, preconditions, simultaneous effects, complete child obligations, postconditions, lazy branches and required observation phases. Authorization of M or I is an additional host/source contract; F does not grant permission by being deterministic. The [existing persistence contract](../sources/core/docs/persistence.md) and [command contract](../sources/core/docs/commands.md) remain the reference for historical profiles.

The compiler produces an admitted plan p with an interpretation `decode_p(machine)=Ω` and retained meaning `J_p(Ω,C)`. C includes exact query/index views, dependency/capture partitions, intermediate outcomes, observation recipes and any maintained aggregate. Every view declares an equality with a function of Ω and its explicitly scoped captures. There is no generic assertion that a cache is valid.

State identity and event identity stay separate. A command-only commit advances history with unchanged live-state identity. Equal command payloads remain separate canonical occurrences. Denied/error attempts do not advance committed history. Their independent attestation, if requested, uses a separate attempt subject; a history proof does not certify unrecorded attempts.

## Application interface

This is pseudocode for the complete interface, not a proposed production patch. `AdmittedModule` means existing semantic admission; `AuthorizedInstall` and `AuthorizedRequest` are supplied through the host's established authorization path, never manufactured by a compiler certificate.

```rust
struct DeltaCore<Storage: AtomicObjects, Proof: MachineProof> { /* private */ }

impl<S: AtomicObjects, V: MachineProof> DeltaCore<S, V> {
    fn install(&mut self, m: AdmittedModule, authority: AuthorizedInstall,
               policy: CompilePolicy) -> Result<InstalledPlan, InstallError>;
    fn open(&mut self, plan: &InstalledPlan, origin: Origin,
            authority: AuthorizedOpen) -> Result<Session, OpenError>;
    fn submit(&mut self, s: &mut Session, parent: ExactHead,
              request: AuthorizedRequest) -> SubmitResult;
    fn export(&self, subject: ExportSubject, target: AuditTarget,
              budget: ResourceBudget) -> Result<AuditStream, ExportError>;
    fn verify(&self, expected: ExpectedHistory, packet: HistoryPacket,
              policy: VerifyPolicy) -> Verification;
}

enum Origin { Genesis(AuthoritativeImport), Resume(DurableHead),
              Migrate(ExactHead, AuthorizedMigration) }
enum SubmitResult {
    Refused(ExactDecision), EvaluationError(ExactError),
    Read { value: ExactRead, observed_at: ExactHead },
    Committed { event: ExactEvent, commands: Occurrences, status: EvidenceStatus },
    Conflict { actual: ExactHead }, UnknownAcknowledgement(RecoveryKey),
    ResourceExhausted(ResumableAttempt), InfrastructureFailure(Failure)
}
enum EvidenceStatus { IndependentlyVerified(CertificateSubject),
                      NativeCommitted { verified_prefix: ExactHead } }
enum Verification { Valid(ExactSubject), Invalid(Reason),
                    MissingSupport(ObjectId), UnsupportedProfile(Profile),
                    ResourceExhausted }
```

`CompilePolicy` fixes allowed primitive versions, proof mode, memory/index budget, evidence profile and optimization budget. It is not a bag of caller-chosen join hints. `InstalledPlan` exposes its full source/profile identity, plan digest, accepted compiler proof identity, resource estimates, incremental coverage and fallback reasons. The application can reject an expensive plan before importing data. Proof checks establish semantic admission of the plan; they do not approve the module for deployment.

`Session` is an opaque native continuation bound to exact history and plan, not portable independent evidence. `submit` starts from the supplied exact parent; a mismatch is Conflict. Requests distinguish actions, invocations and declared reads. A read returns its exact value/error and observed head without publishing an event; an independent attestation of that read is a separate request-bound claim. For an action, the machine resolves all bindings before deriving a simultaneous identity-indexed delta. It computes all reads/effect right-hand sides at their specified phase before constructing S′, then validates the prescribed obligations in canonical order. An alias cannot double-count one entity. There is no per-request witness argument and no caller-provided list of affected obligations.

In synchronous mode, Committed means the required certificate was independently checked and referenced objects/proof are durable under the adapter contract before the head is acknowledged. In explicit asynchronous mode, Committed reports the exact independently verified prefix. A constructed fold is not independently verified progress. Defaulting silently from synchronous to asynchronous is forbidden. Resource failure cannot become a business denial, and a failed post-publication operation must still report committed/unknown status rather than claim rollback.

`export` names full audit, state reconstruction or a precise command interval; it reports missing support instead of treating missing objects as empty queries. `verify` uses independently selected code/keys and an expected anchor, module, profiles, position and endpoint. It never takes the producer's own acceptance as a premise. A caller who needs current authorization or availability separately asks the host/data protocol for those findings.

Example use is `install → open(genesis/resume) → submit(exact parent, authorized request)`. For an invoice module, installation derives field-key indexes and order-aware sum programs from the actual admitted queries. Application code submits `record_payment`; it does not construct a count proof, install arbitrary view names or enumerate changed constraints. A new query causes a new certified plan, potentially rebuilding views; it does not silently change the installed plan's meaning. A fresh independent recipient calls `verify(expected exact head, exported history certificate)` and can separately request the full audit stream.

## Hidden implementation and extensibility

The implementation has a typed source elaborator, explicit evaluation-order intermediate representation, change algebra, plan certifier, deterministic bytecode machine, persistent indexed memory, observation interpreter and proof adapter. These are private implementation modules behind the installed-plan seam. The compiler is not imported DBSP execution under a new name.

1. **Elaborate every declaration.** Preserve complete action/read/derived/rule inventories, resolved types/calls, metadata and profile-specific order. Structural coverage is mandatory even for uncalled branches. A semantic BehaviorHash alone may omit metadata that affects reported observations; the source subject binds that metadata too.
2. **Make partiality and sequencing explicit.** The intermediate representation uses typed `Result`, ordered `bind`, `guard`, separate query-materialization and fold stages, explicit frames/memo state, phase labels, observation events and command occurrences. Algebraic rewrites operate only across proved commuting/total operations. An optimizer cannot reorder errors because it found a cheaper join.
3. **Derive initialization/change programs.** For a primitive f, retain `Init_f`, `Step_f`, its cache relation, valid-change relation, exact result/observer law and complexity parameters. Compose those laws through the explicit control structure. Dynamic branches retain activation information; activating a formerly unused branch initializes its required computation from complete inputs. Capture changes are input changes, not cache hits.
4. **Certify the chosen plan.** An untrusted search optimizer may choose indexes, sharing and rewrites; a small proof checker validates its typed proof DAG against the exact source and a versioned primitive-law registry. The proof is per plan, not a caller-supplied execution witness per operation. Search budget exhaustion selects a certifiable reference plan or an installation resource error; no unproved rewrite is accepted.
5. **Execute one deterministic target language.** Native execution and the accumulated proof refer to the same bytecode semantics. The proof relation authenticates bytecode/instruction fetch and state access and checks actual steps, program counter, request and transaction completion. Plan certification establishes what this bytecode means; a separate executable-correspondence result must establish what the machine implementation does.

Extensions add a typed source primitive plus its source meaning, cache relation, init/change laws, observer/error/order law, target lowering theorem and storage interpretation. Rewrites add proof rules with precise premises. They can support richer predicates, graph summaries or decimal operators without extending the application's method set. This is the intended flexibility. An arbitrary Rust plugin with an unchecked Boolean “safe” result does not enter the registry. Adding a primitive changes the trusted/proved registry identity and requires renewed admission; it may change circuit/guest support and preparation costs.

Index selection has no assumed polynomial global optimum. The initial plan can use per-type ordered IDs, used-ID membership, complete reverse-reference counts and expression-specific views. An adversarial module may demand many indexes, many captures, nested queries or high-fanout joins. Cap view proliferation; report estimated cold construction, retained bytes and worst-case update work. Unbounded context-key memoization is not a space bound. Eviction is safe only with a semantics-preserving reinitialization path; its latency is charged to the next demand. Runtime plan adaptation is a certified view-conversion transition with complete old/new J, not a hidden mutation of program meaning.

Use an in-memory adapter for ordinary immutable maps/ordered sequence trees and exact-head atomic publication; use a durable adapter implementing the same read/opening/update/publication laws with copy-on-write objects, checksummed/authenticated encodings, journal/root durability and crash recovery. The in-memory adapter explicitly provides volatile publication and cannot satisfy a requested durable endpoint; installation/opening checks that capability. The storage interface returns authenticated presence/absence or explicit failure, never “not found” for transport corruption. Native trusted storage can avoid unnecessary proof-path serialization; the independent proof machine still authenticates any memory supplied by an untrusted host.

The proof adapter consumes an execution of the fixed bytecode machine and returns a certificate for its public subject. A native replay adapter and an accumulated-proof adapter provide two concrete implementations at that seam. Replay remains a legitimate linear comparator, not a claimed succinct solution. Prefer a small existing proof implementation only after freezing curve/commitment/compression/setup/parameter/security identities and establishing machine correspondence. No dependency installation is proposed here. DBSP, ILC and CTS are proof/algorithm references; copying their complete runtimes would not settle Core's semantics, storage or lifecycle contract.

## A concrete ordered checked-Int64 aggregate law

This written result handles a finite sequence of **total, pure, Int64-valued projections**, in Core's canonical member order, with checked addition from zero. It is not a theorem for partial projections, all numeric types or full observations. The [actual fold](../sources/core/crates/behavior-core/src/eval.rs) checks `i64::checked_add` after evaluating each body. The [query matcher](../sources/core/crates/behavior-core/src/eval.rs) can evaluate partial filters before this fold; that stage requires its own law.

Let `L=−2^63`, `U=2^63−1`. For a sequence x, define using mathematical integers:

`T(x)=Σx`, `lo(x)=min({0} ∪ all prefix sums)`, `hi(x)=max({0} ∪ all prefix sums)`.

The empty summary is `(0,0,0)`. Ordered concatenation has the law

```text
(t,a,b) ⋄ (u,c,d) = (t+u, min(a,t+c), max(b,t+d)).
```

Every prefix of xy is either a prefix of x or all of x plus a prefix of y. This proves the law and its associativity by equality with the sequence meaning. It is an ordered monoid; its operation is not commutative. If the incoming accumulator z is in `[L,U]`, the checked fold through x succeeds **iff** `L ≤ z+lo(x)` and `z+hi(x) ≤ U`; on success it returns `z+T(x)`. Each actual intermediate accumulator is exactly z plus its prefix sum until the first overflow, proving both directions. This preserves overflow that an unordered final sum would erase: `[U,1,−1]` has final mathematical sum U but fails at the second member, whereas `[U,−1,1]` succeeds.

A balanced canonical-key sequence tree stores these summaries. Change/insert/delete of d projection leaves refreshes the affected search paths, preserving the summary equality by the concatenation law. If the root is unsafe, descend left first: skip a left subtree only when its safe test holds, add its total exactly, then inspect the right subtree. The first failing leaf identifies the same overflow point as sequential checked addition. Root safety needs constant many integer comparisons; first-error location needs tree height. Ties/order are fixed by typed identity, not optimizer traversal order. Summaries use arbitrary-precision integers, not wrapping Int64: a block of n Int64 values needs O(64+log n) magnitude bits. Thus O(d log n) denotes tree operations with growing integer costs, not constant-time bit arithmetic or a millisecond promise.

For pure total projections and total membership predicates with fixed captures, leaf maintenance needs only the complete affected rows. A field read can satisfy this fragment after typing and input validity establish totality. The defining equality also covers absent/deleted members and insertions into previously empty sets. Initialization must enumerate the authoritative ordered members and calculate leaves; an authenticated summary imported from an unproved source is rejected. Totality is a proof obligation, not an assumption inferred from a previously successful sample.

The summary establishes value/error location, **not** complete Core evidence. The plan additionally proves that an observation recipe reads the same members/fields and expands the exact successful prefix and skipped/error entries at the prescribed phases, with source attribution. Under a new compact profile, the recipe plus exact state/version roots can stand for that observation sequence; materializing all entries remains output-sized. Under an old profile, constructing/hashing the old flat record stays on the required path. Observer effects involving derived memo state, rescale entries, bound-target suppression or partial evaluation need their own correspondence; until proved, the compiler uses the complete reference program for that expression/phase.

Any/All need a different ordered summary: first decisive result versus first error, with skipped tails, and the exact distinction between materialized `where` and lazy fold body. A union cannot blindly short-circuit its right predicate: the inspected Core matcher evaluates both sides before combining their Booleans. The compiler cannot import ordinary Boolean or relational identities where their error/observer behavior differs.

For general checked multiplication/division, fixed-scale decimal/nominal/exact/rescale semantics, partial filters, data-dependent projections or unsupported observer effects, the initial safe choice is full ordered reference lowering. A finite sequence can always denote its whole ordered accumulator transformer, but that representation can grow with the sequence and updates can be linear; naming it a summary does not solve its cost. No general signed numeric aggregate optimization follows from this one addition law.

## Complete view meaning and negative facts

For a selected type T and capture k, a compiled view states `Members(q,Ω,k) = {typed IDs in Ω satisfying the exact q evaluation contract}` with canonical sequence/error information, not merely a subset whose members pass. For a total query, count is the exact size of that set. The change program subtracts old contributions and inserts new ones for a **complete simultaneous delta**; it includes updates to predicate fields, captures, target existence and query/set dependencies. Partial queries use an ordered outcome representation or reference execution, not an empty set after an error.

Dependency selection comes from the admitted whole program and complete indexes. New rows are routed through the query's domain even if its previous result was empty. A range-index plan has exact ordered key/value semantics and authenticated gap/boundary coverage; all range candidates are evaluated unless a proved summary discharges them. Arbitrary predicates may require scanning the full type partition. A reference index equals **all** surviving incoming typed edges, counting distinct holder/field occurrences as required; every removal/retarget/creation updates it. Simultaneous deletion validates the surviving-child graph, not transient intermediate graphs. “No incoming edge” then means exact maintained zero under J; a zero opened from a root with no initial/maintenance proof is insufficient.

Captured thresholds can invalidate many members without writing them. A specialized value-order index may answer some threshold queries cheaply, but an arbitrary changed capture may require Θ(N) fresh predicate work and observation support. A one-cell update can invalidate most cached computations. This is a cost of the chosen query/summary/update contract, not a universal lower bound for every representation.

For independent use, either the proof executes the complete maintained view program under J or it recomputes the relevant query in authenticated memory. Checking supplied row membership is never the completeness argument. The structural plan proof covers every declared obligation and its canonical schedule; an untrusted executor cannot provide a convenient subset. Authenticated memory ensures the fetched values match roots, while compiler/init/update proofs establish why the views and access pattern are sufficient.

## One correctness chain, including executable correspondence

The following are **required new theorems**, not completed claims. Let `Cert(M,P,p)` be accepted plan certification and `Run_p` the formal deterministic bytecode execution. Let `A_p` express valid operational data, exact J, admitted plan/source/profile identity, canonical encodings, state/view roots and exact history. Let Obs be the interpretation of the compact observation recipe.

```text
Plan soundness:
  Cert(M,P,p) ⇒ (Init/Step/Expand of p refine exact F(M,P)).

Initialization:
  ValidOrigin(Ω0) ∧ Cert(M,P,p) ∧ Run_p(Init, Ω0, C0, Z0)
  ⇒ A_p(Ω0,C0,Z0).

Transition:
  A_p(Ω,C,Z) ∧ fixed original I ∧ Run_p(Step, Z,I, result,C',Z')
  ⇒ result/Obs = F(M,P,Ω,I) ∧ A_p(Ω',C',Z').

Publication:
  exact-parent Applied CAS ∧ durable event/support ∧ transition premises
  ⇒ the installed canonical continuation is that exact Z'.

History:
  accepted Init plus accepted complete Step executions through H
  ⇒ the exact F-history, command occurrences and endpoint through H.
```

Refusals/errors preserve canonical Ω/C and emit the exact result; speculative child caches are discarded. Attempts, commits and proof microsteps have separate counters. A proof relation permits incomplete transaction microsteps internally, but a published event needs its completion marker with the original request/context unchanged. Extra unused proof steps cannot masquerade as extra committed history.

Plan soundness requires structural induction over an explicit sequencing/error language; relational primitives can use separately proved change laws. Its conclusion includes observations, not just truth or safety. It must cover both derivative validity and new-cache validity; proving only that `old_result ⊕ delta_result = new_result` leaves future transitions unjustified. Resource estimates are separate statements: semantic soundness does not prove a fast derivative.

Executable correspondence then needs a separate commuting diagram:

```text
actual admitted Core IR --semantic interpretation--> formal F
         | certified lowering                            |
         v                                               v
installed bytecode --formal machine execution--> exact output/next Ω
         | executable refinement                         |
         v                                               v
machine implementation + adapters --------> concrete encodings/objects
```

One route is a machine-checked executable reference semantics and certifier, verified extraction/compilation for the bytecode interpreter, and adapter refinement to authenticated ordered dictionaries and crash-safe publication. Another route retains trusted Rust/toolchain/adapters with a clearly conditional theorem. The latter may be useful engineering but cannot be called an end-to-end machine implementation proof. Native optimized machine execution and circuit/guest execution each require correspondence with the **same** formal machine. A VM proof of arbitrary bytecode execution does not establish that its bytecode means Core without the accepted plan certificate.

Existing Core032 Lean results establish a restricted logical model, with Rust/Core/R1CS/encoding/crypto correspondence explicitly trusted. Differential and adversarial tests would support this new correspondence but cannot prove its arbitrary-program quantifiers. Required future controls include wrong/missing plan declarations, stale captures, omitted new query members, extra members, wrong ref/used-ID inventory, overflow cancellation, lazy error precedence, derived memo/rescale effects, duplicate commands, wrong metadata and equal-state/wrong-history parents. No such new checks ran for this proposal.

## Independent history binding and evidence

Use a new explicitly versioned compact evidence profile. Its public subject Z binds unambiguous typed encodings of genesis/lineage, exact event head and logical position; live and lifetime-ID roots; view/index roots; complete source/schema/profile/policy identity; certified plan and primitive-registry identity; bytecode-machine/proof-relation identity; original input/context commitment; and normative observation/command-stream commitment. Exact event encoding includes original publication metadata. The observer commitment has an explicit interpreter; it is not a promise that a hash denotes the right trace.

An accumulated proof covers initialization and all completed machine executions under the certified plan, including authenticated memory/index maintenance and commitment updates. A fresh verifier independently checks the accepted certifier/registry/machine identities, expected anchor, proof/parameter identity, logical H and final exact subject. It need not fetch every historical input for semantic prefix verification if the proof soundly establishes those inputs' committed execution. Full provenance review and export may require fetching them. A proof from an explicitly trusted checkpoint proves only that continuation, unless the checkpoint itself includes a checked prefix proof back to the accepted origin.

An old-profile prefix is handled by an accumulated proof of exact old semantics/encodings or an independently replayed exact bridge followed by a new-profile segment. The latter costs the full old prefix and is reported as such. Keeping old decision hashes requires constructing/processing their canonical bytes somewhere, including inside the proved bridge if that is the accepted claim. The new profile cannot silently retain old event IDs while replacing their contents. If old StateId/MuHash3072 remains a public identity, the init/step relation establishes common-source correspondence with the authenticated memory root, including its exact hashing and non-native arithmetic costs. Publishing two unrelated roots proves no correspondence.

Native reference fallback is included in the proved target semantics; the proof producer must execute/prove it too. An opaque “host checked Core” instruction is forbidden. Before the full reference lowering and machine correspondence exist, the honest result for an independent proof on unsupported constructs is UnsupportedProfile. That means the candidate is incomplete for those modules; native fallback cannot cure the missing independent-history guarantee. This is a release gate for complete Core, not an excuse to benchmark only easy modules.

The retained data is a sufficient representation: exact original inputs/context and authority evidence under its stated source contract, admitted source/plan versions, immutable delta/events, state/version support, observation recipes and all referenced preimages needed for promised reconstruction. Sharing may replace repeated copies. Garbage collection uses reachability from every retained audit root/retention promise and active proof continuation; it cannot drop lifetime identities just because entities are removed. Missing data is a separate availability outcome, even if the prefix proof remains valid.

## Bootstrap, recovery, migration and durability

**First initialization:** admit/authorize the exact module, certify the plan and establish a valid origin. For raw authoritative input, enumerate/check the complete import, typing/reference/global rules and lifetime inventory; construct exact views and commitment encodings; prove that initialization if independent certification is promised. An imported root alone is not initialization. Used IDs require complete source history or an accepted exact inventory certificate. The producer reads the import at least once; a fresh verifier can avoid repeating that read only by checking a sound initialization certificate or accepting an explicit trusted origin. Data retrieval still costs its actual bytes.

**Cold resume:** authenticate the durable exact head, accepted plan and proof subject; reopen paths lazily under those roots. Checked persisted view roots may resume J only because the prior proof establishes their defining meaning and the storage/proof interpretation matches. They cannot inherit authority from a file name or native type. Missing/corrupt required paths stop or rebuild from complete retained authoritative data. Loading the entire state, proof parameters, continuation witnesses or indexes may be necessary for a particular adapter and is measured. A compressed public certificate need not contain enough state to continue proving.

**Publication/recovery:** prepare copy-on-write state/views/event/support and proof outside final exact-parent CAS; make referenced objects durable before durable root acknowledgement under the selected adapter's crash model. CAS losers discard speculative continuations; any proving cost they incurred is real. Recover persisted-before-ack by the original event/recovery key, returning its canonical occurrence identities without duplicate commit or command replay. External delivery uses the host's existing occurrence/deduplication policy; mathematical execution does not prove exactly-once physical effects. Disk durability and hostile-server authentication are separate laws; a verified crash-safe dictionary is not automatically an authenticated database.

**Module/plan migration:** authorize the change through existing governance; preserve the exact old history; certify the new module/plan; establish the explicit state/lifetime/source interpretation and new invariants; build or certify converted views. Join old proof endpoint and new init subject with a migration theorem. A reusable universal machine can treat certified plan changes as data, but checking a new certificate and reinitializing views still costs work. Specialized circuits can need new keys/parameters and compression setup. A shared schema or universal setup does not authorize a module switch. Unproved migration is a new explicitly trusted segment, not inherited proof of the old chain.

## Why the work can change, and where it does not

The distinction from Core032 A is that ordinary updates execute a derived maintenance program whose preservation is established at plan admission; they do not rebuild complete J and compare full Core after every operation. The distinction from B is that the application does not provide per-transition semantic derivations: a certified program determines coverage. The independent execution proof witnesses machine steps internally, as any computation proof does, but its semantic interface is installed bytecode and plan certification, not a caller's open-ended witness calculus.

The distinction from the final compatible patch is that compact events commit to interpreted exact observations with retained support, rather than eagerly flattening all old trace rows into each new event. Returning the same full old bytes still incurs their production/hashing costs. The distinction from simply importing DBSP is preserving Core's ordered partial semantics and observations in a certified source-to-target translation, and supplying lifetime/history/persistence/authority contracts that a stream algebra does not define.

Let N be live input size, U lifetime-ID size, H committed events, D changed values, A all affected intermediate/index dependencies, B requested full-output bytes, Q actual predicate/body cost, W new input/support bytes, M retained memory, K machine proof microsteps and C their encoded relation sizes. A may equal or exceed N for a tiny D. No bounded-N/H/D/B assumption is implicit.

| Phase | Charged work and conditional bound; no new measured latency |
|---|---|
| Admission/compile | Source parsing/admission + plan search + certificate construction/check + code/proof-image generation. Search/proof size can be large; optimization budgets may return a slower plan. Circuit/parameter changes add setup/preprocessing. |
| Raw initialization | Read/import/validate Ω, complete used-ID inventory and origin; build all selected indexes/caches, sort if necessary, generate initialization proof and commitments; durable publication. At least input-reading work under this raw-import access model; history-derived IDs can add replay until a justified exact index exists. |
| Eligible local native transition | Request/authentication + binding/effects + actual affected work A·Q + changed persistent paths + W encoding/hash + exact-parent durability. Selected tree operations can be O(D log N), with integer/hash/byte costs explicit. Old flat-output mode adds B construction/hashing; a global/capture change can require full recomputation. |
| Proof production | Execution/witness generation + authenticated paths/memory consistency + exact hash/identity constraints + Σ actual microstep proving cost + finalization/closure + chosen compression. K is not H; scans/export hashing inside the relation remain proving work. Concurrent losers/retries and proof state writes count. |
| Independent prefix verification | Transfer proof/public subject/plan or reusable certificate + key/parameter derivation/load/validation + proof verification + expected-subject comparison. History dependence can be removed conditionally by accumulation; dependence on machine/circuit size, parameters, security and public bytes remains. Old full-replay bridges restore H/evidence dependence. |
| Full export/data audit | Fetch/authenticate retained preimages, execute exact recipe/reference reconstruction and stream B requested bytes; historical/data audit checks its promised complete scope. Accumulated semantic validity does not replace inspecting every object when that is the requested claim. |
| Cold recovery/migration | Root/plan/parameter validation, required data and prover-continuation loading, J rebuilding if persisted meaning is unavailable, migration validation/index conversion/new proof setup, then catch-up. Worst case includes complete retained history and input. |

This can replace repeated Θ(N) evidence construction and repeated H-prefix checking with affected native computation plus a separately accumulated history certificate **for eligible plans under the new evidence contract**. It is a conditional architectural improvement, not a universal bound. All aggregate/index/view state may occupy O(N) or much more across expressions/capture partitions; lifetime IDs and full audit retention grow independently of live N. Persistent sharing avoids repeated unchanged objects, not the requirement to retain distinct historical facts.

Measure contiguous complete scenarios: first deployment through independently accepted initialized head; cold restart through accepted continuation; request arrival through durable, independently verified commit; fresh consumer through exact history acceptance; and requested full audit availability. Also report lifecycle total `compile + init + all updates/proofs + parameter/recovery/migration + all requested exports/checks`, without summing overlapping phase medians. Synchronous mode includes proof/compression/verification on its latency path. Asynchronous mode reports native latency, actual independently verified prefix, age/bytes of backlog, arrival-to-verification latency, catch-up cost and sustainable producer rate. Warm caches and resident keys are permitted amortization only with declared lifetime, memory and cold rebuild charges.

The existing 032 first-use/reuse H2 producer/consumer medians of 68.818 s / 22.487 s and cold N8192 reconstruction at 37.763 s are scoped prototype facts, not predictions for this compiler. They demonstrate that preparation and recovery can dominate. The single-create and later compatible optimization milliseconds belong to different frozen workflows and cannot be combined into a synthetic speedup. See [actual lifecycle evidence](../sources/core/specs/032-transition-verification-study/evidence/cost-model.md).

## External theorems: conditional reuse only

The pinned [ILC theorem inventory](https://github.com/inc-lc/ilc-agda/blob/39bb081c6f192bdb87bd58b4a89291686d2d7d03/PLDI14-List-of-Theorems.agda) exposes differentiation correctness under the primitive/change interface; this motivates deriving changes. Core must instantiate the primitives and explicit sequencing/partiality/observer semantics correctly. The [CTS theorem overview](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/Overview.v) explicitly relates valid environment changes and old/new terminating computations with cache transformations; its [declared assumptions](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/README.md) include extensionality axioms. Neither establishes target-machine, persistent-cache or resource correctness for Core.

The pinned [DBSP transformation](https://github.com/tchajed/database-stream-processing-theory/blob/fb6ff4416108710448ccd87473c5513c1a1179ea/src/circuits.lean) applies under algebraic and primitive-recognition premises. It supports separately proved total relational primitives; it does not justify checked numeric reassociation, lazy filter changes or ordered observations. The ordered checked-add law above is an additional Core-directed mathematical argument, not a result imported from DBSP. No external artifact was built, kernel-replayed or axiom-audited for this document.

[Authenticated ordered range protocols](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf) supply specific completeness mechanisms, including boundaries, under an accepted endorsed root. They do not prove that Core built/maintained the complete index. [Pinned Nova implementation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/nova/mod.rs) separates parameter setup, recursive extension/verification and compression. Its proof verifies the selected relation and expected endpoint only after the application binds them correctly. None of these sources supplies the full Core theorem or any Core millisecond guarantee.

## Tradeoffs and rejection criteria

This alternative offers more maintainable extension points than a tiny fixed semantic kernel and less per-operation proof-structure knowledge for applications than a semantic-witness interface. Its cost is a much larger proof-preserving compiler, primitive registry, observation language and machine-correspondence project. Compiler search and index choices can produce expensive initialization, memory or bad update plans even when perfectly sound. Per-module specialized proof relations may be faster but increase key/setup/migration lifecycle costs; a universal bytecode relation improves plan extensibility while adding machine overhead. These must be measured, not settled by a slogan about universal versus specialized execution.

Reject it as the selected complete architecture if any of the following remains true:

- Certification proves only final values/invariants while losing selected errors, metadata, observations, query completeness, command occurrences or full declaration coverage.
- The ordinary path rebuilds complete J/Core to justify every derivative, eagerly renders all expanded traces under the claimed compact profile, or hides a full identity bridge outside the independent proof.
- Required full Core constructs or migrations are host-only fallback while the product claims the same independent history guarantee. The concrete gaps include Decimal/nominal/exact arithmetic and rescaling, derived frames/memo, Option/enum migration semantics, partial set/query/fold pipelines, references/lifetime rules, reads/invocation and historical profile behavior.
- Compiler/certifier/VM executable correspondence is assumed while described as machine proved; arbitrary optimizer or producer tokens are accepted as authority; omitted declaration/dependency or empty-query mutations can pass.
- Workload-relevant capture changes, high fanout, fallback rate, view-space growth, compilation, initialization, proof/compression/verification, cold recovery or durable publication defeats the declared latency/capacity envelope.
- Proof backlog grows under declared sustained arrivals; fresh verification or data export cannot meet its stated contract; unavailable support is misreported as valid empty data; or recovery duplicates event/command occurrences.

The next discriminating implementation would certify one complete module with a nontrivial count, ordered checked signed sum, reference/lifetime behavior and duplicate commands, plus exact full-reference fallback, then establish its init/update/history/implementation correspondence and measure every phase above. This document supplies a concrete candidate and obligations; it does not claim that work has been completed.
