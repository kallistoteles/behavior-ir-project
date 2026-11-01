# Candidate 3: a certified transition module for the ordinary caller

Date: 2026-11-01. Status: architecture proposal, not an implementation, completed proof or latency result. No production source, sealed evidence, build or test was changed. This candidate applies the codebase-design vocabulary: a **module** has an **interface** and an **implementation**; a **seam** is where an interface lives; an **adapter** satisfies an interface at a seam.

The ordinary caller opens one module, supplies an action and captured context, and receives either the exact semantic result with a certified receipt or an operational failure. An untrusted executor finds efficient derivations. A small fixed semantic checker checks them. Persisted state carries a certificate for its meaning, and a compressed accumulated proof lets a fresh consumer verify the same history without replaying Core. Witness production, authenticated indexes and proof configuration stay inside the implementation.

The default is **synchronous certification**: a successful action receipt means its exact committed history prefix has been independently cryptographically verified and durably published. This deliberately exposes proof production and compression on the ordinary critical path. If that path cannot meet the intended absolute budget, this candidate fails that budget; moving proof work to a background queue would be a different interface and guarantee.

This is not a claim that a proof eliminates initialization, global computation or data transfer. It is a way to concentrate those obligations behind a small interface and permit arbitrary producer optimizations without trusting them.

## What differs from the other two architectural choices

The essential seam is **proposal versus acceptance**. The executor may be replaced without changing what the checker accepts. The checker validates a derivation of the complete transition, including justified reuse; it does not run a full reference execution merely to compare a proposed poststate. Its fixed rules include evaluation, complete coverage, authenticated access, exact summary maintenance and framing of unchanged obligations.

Unlike a direct semantic kernel, ordinary execution strategy and witness search are outside the trusted implementation. Unlike an incremental compiler, no caller-selected primitive algebra, derivative generator or compiler extension can introduce a trusted maintenance rule. A producer may compile or cache whatever it likes, but its proposed reuse must pass the same fixed checker. Static analyses used to justify coverage must themselves be verified or checked, not silently trusted because an optimizer emitted them.

This design does combine authenticated state and accumulation, for a specific reason rather than as a menu of mechanisms: sparse checking needs justified reads and complete views, and fresh history verification needs a proof of the same checker from its justified initialization. Removing either leaves one of the three required stages unsolved. A general incremental compiler is not required for this candidate; efficient witness search can begin with specialized untrusted executors.

## Source coverage and what it changes

The numbered inventory is [the 13-investigation map](../../investigation-map.md). Each source below is primary evidence from the retained Core investigations, or its original research artifact. Findings are not treated as proof of this proposal.

| Investigation | Read evidence and consequence for this candidate |
|---|---|
| 1, Core029 | [Evaluation report](../sources/core/specs/029-incremental-global-validation/evaluation-report.md), [correctness](../sources/core/specs/029-incremental-global-validation/correctness.md), [runtime contract](../sources/core/docs/incremental-validation.md). Existing exact-parent local/count reuse is real but narrow; complete observations remain expensive. Private checked tokens are useful internally but cannot certify a remote producer. |
| 2, Core031 | [Full investigation](../sources/core/specs/031-scalable-execution-evidence/investigation.md). All five areas matter: evidence processing, broader queries, compact evidence, history verification, and identity/retention. Predicate reuse alone did not remove the growing cycle; small command pages still incurred prefix work. |
| 3, single creation | [Profile](../sources/core/specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md). At N8192 one decision is 4,085,191 bytes, about 79% trace; the measured evaluate/commit medians were 277/1,658 ms. A genuinely different ordinary path cannot eagerly rebuild/hash that full record and call it sparse. |
| 4, architecture/authentication | [Architecture options](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/architecture-options.md), [authenticated structures](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/authenticated-structures.md). Typed reuse, complete range evidence, persistent objects and crash refinement solve different obligations. A DAG hash proves none of their semantic correspondence by itself. |
| 5, first principles | [Research](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md), [derived alternatives](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/derived-architectures.md), [limits](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/obligations-and-limits.md). This candidate selects the independent semantic-checker alternative and makes its coverage and exact-result theorem explicit. |
| 6, greenfield | [Research](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md), [composition](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md), [IVC comparison](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/ivc-findings.md). C1, proof of a semantic witness checker, is a prior hypothesis, not a new discovery. This proposal supplies a concrete interface, release/proof chain and publication contract for that hypothesis. |
| 7, Core032 | [Full investigation](../sources/core/specs/032-transition-verification-study/investigation.md), [proof lifecycle](../sources/core/specs/032-transition-verification-study/evidence/proof-lifecycle.md), [cost model](../sources/core/specs/032-transition-verification-study/evidence/cost-model.md), [trust ledger](../sources/core/specs/032-transition-verification-study/evidence/correspondence.md), [batch correspondence](../sources/core/specs/032-transition-verification-study/evidence/batch-checker-correspondence.md), [circuit correspondence](../sources/core/specs/032-transition-verification-study/evidence/circuit-correspondence.md), [transition contract](../sources/core/specs/032-transition-verification-study/contracts/transition-contract.md), [proof contract](../sources/core/specs/032-transition-verification-study/contracts/proof-and-evidence.md). B is an exact full-replay baseline, not this sparse checker. A checks full J. The real Nova relation omits the exact Core identity bridge, supports a small fixed fragment and has no compression. Those are explicit design gates here. |
| 8, strict decoding | [Report](../../core-continuation-20261029/report.md). Reuse checked ingress inside one call; do not weaken lexical validation or error precedence. Its 8.6–10.9% observed commit improvement does not change output growth. |
| 9, typed materialization | [Report](../../core-typed-record-20261031/report.md). Array-shaped traces expose real parser/error differences; proving a pleasant typed model is insufficient. The new profile must specify parsing and legacy conversion explicitly. |
| 10, residual profile | [Report](../../core-residual-profile-20261031/report.md). Materialization, hashing and ownership remain substantial; byte counters perturb the workload. Measure complete ordinary operations and cold phases with uninstrumented binaries. |
| 11, bundle ownership | [Report](../../core-bundle-ownership-20261031/report.md). Moving an owned bundle removes a real clone, but gains are mixed and allocation lifetime matters. Typed ownership belongs inside this module, not in caller workarounds. |
| 12, final compatibility/allocator study | [Report](../../core-final-investigation-20261031/report.md). The cumulative candidate improves measured evaluate+commit+first-output medians 22.06–30.82% while keeping full bytes. Small v2 first output still regresses; deferred allocator work explains why an interior speedup is not a whole-workflow result. This proposal must beat that improved comparator, not only the old baseline. |
| 13, reassessment | [Scope](../../core-redesign-reassessment-20261101/scope.md), [prior evidence](../../core-redesign-reassessment-20261101/prior-design-evidence.md), [researched alternatives](../../core-redesign-reassessment-20261101/researched-alternatives.md). Startup, ordinary transitions and fresh historical verification form one claim and one lifecycle budget. Milliseconds are an ambition with no result established for this candidate. |

The external precedents are deliberately narrower. [CompCert's allocation validator](https://compcert.org/doc/html/compcert.backend.Allocation.html) illustrates validating an untrusted optimizer. [cake_lpr](https://cakeml.org/tacas21.pdf) demonstrates a verified checker with a machine-code correspondence story; it supplies neither a Core checker nor a circuit compiler. [Authentikit](https://iris-project.org/pdfs/2025-ccs-veriauth.pdf) mechanizes authenticated computation/reuse in its language; compiled OCaml faithfulness and the benchmark serializer have stated qualifications. Its theorem does not certify a persistent Core semantic cache. These are design precedents, not dependencies to concatenate and declare proved.

## The ordinary interface

Illustrative types specify semantics, not proposed Rust production declarations. `Bytes`, `Digest` and IDs are typed, length-delimited values; digests from different domains cannot be substituted.

```rust
struct Deployment {
    subject: Subject,               // complete admitted program/schema/policy/profile
    trust: TrustAnchor,             // independently selected authority + genesis expectation
    release: CheckedReleaseId,      // checker, semantics, circuit and parameter recipe
}
struct Subject {
    program: ProgramId, schema: SchemaId, policy: PolicySetId,
    semantics: SemanticsId, evidence: EvidenceProfileId,
}
struct Head {
    lineage: LineageId, commits: u64, record: EventId,
    state: StateRoot, semantic_views: ViewRoot, outputs: OutputRoot,
}
struct Request {
    id: RequestId, action: ActionId, bindings: Bindings,
    input: CanonicalInput, context: CapturedContext,
}
enum Outcome {
    Allowed { event: EventId, commands: Vec<CommandOccurrence> },
    Refused { exact: SemanticRefusal },
    EvaluationError { exact: SemanticError },
}
struct CertifiedResult {
    outcome: Outcome, parent: Head, committed: Option<Head>,
    claim: AttemptClaim, certificate: PortableCertificate,
}
struct VerifiedHistory { anchor: Anchor, head: Head, subject: Subject }

Core::initialize(repo: Repository, deployment: Deployment, genesis: Genesis)
    -> Result<Core, OpenError>;
Core::open(repo: Repository, deployment: Deployment)
    -> Result<Core, OpenError>;
core.apply(request: Request) -> Result<CertifiedResult, ApplyError>;
core.read(request: ReadRequest) -> Result<CertifiedRead, ReadError>;
core.export(at: Head, selection: ExportSelection) -> Result<Export, ExportError>;
Core::verify(expected: ExpectedHistory, packet: PortableCertificate)
    -> Result<VerifiedHistory, VerifyError>;
Core::audit(expected: ExpectedHistory, archive: AuditArchive)
    -> Result<AuditReport, AuditError>;
```

Ordinary use is two calls after deployment configuration:

```rust
let core = Core::open(Repository::durable(path)?, approved_deployment)?;
let result = core.apply(Request::action(request_id, action, bindings, input, context))?;
// Only Allowed contains committed command occurrences. Host delivery is explicit.
```

`initialize` is required only for a new lineage or explicit adoption. `open` checks the deployment expectation, persisted certified head and continuation data. It never substitutes an unchecked local snapshot when a certificate or node is unavailable. `apply` captures a current exact parent internally, evaluates only supplied immutable input/context, and attempts one exact-parent publication. `read` uses a declared read under the selected exact head and binds its result/context/query to authenticated state; it must obey the same partial/error semantics as action expressions.

The interface includes the following obligations and errors:

* The caller selects the authoritative deployment and supplies the complete context it intends to attest. A certificate proves computation over those bytes, not that an external fact or identity claim is true. Context evidence may be verified under the deployment's declared authority rule; changing that rule changes the subject.
* Same request ID plus identical canonical request returns the original result after a lost acknowledgement. Same ID with different bytes returns `RequestIdReuse`. IDs are scoped to lineage; the durable request index is part of the publication transaction. No second command occurrence is created by retry.
* `Conflict { expected, actual }` means a competing parent won. There is no automatic semantic rebase. The caller can resubmit its intent under a new request ID/context, or retry the identical ID after resolving whether it committed. Its original result cannot acquire authority at a new parent.
* Semantic refusal and evaluation error are successful checking results with the exact original code, subject, phase and ordering. They leave the committed head unchanged and carry a standalone attempt proof bound to that parent/request/context. They are not fabricated committed events. A private durable request-result index may retain their receipts without altering semantic history.
* `Unavailable`, `CorruptSupport`, `InvalidCertificate`, `UntrustedDeployment`, `ResourceExhausted`, `ProofProductionFailed` and `StorageFailure` are operational results. They are never converted to semantic refusal. An invalid producer witness is retried through a built-in complete witness producer; if that also fails, the operation fails operationally and publishes nothing.
* `CommitUnknown { request_id }` is reserved for uncertain acknowledgement. Repeating the exact request resolves it against durable history/request identity. A transport timeout is not evidence of absence.
* Finite limits are declared in the release: request/node lengths, recursion/decoder limits, integer ranges and maximum proof microsteps per invocation. Exhaustion cannot silently change language semantics. Full admitted-language coverage remains a requirement; a restricted prototype must report its unsupported fragment explicitly.
* `verify` consumes data only and uses installed independently selected tools. Producer-supplied executables, checker binaries or verifier keys never gain execution or trust authority through a packet. `audit` is a separate operation because it promises historical data inspection and first-divergence reporting.

The caller neither implements `produceWitness` nor supplies arbitrary verification callbacks. Those would expose the difficult coverage, lifetime, retry and proof lifecycle obligations at every call site. The module earns depth by hiding them. Application-specific state arrives through the existing declarative program and context, not a callback that can redefine accepted meaning.

## Hidden implementation and genuine seams

An executor reads immutable authenticated objects, proposes effects and a derivation, and may use native compiled code, a database optimizer or specialized caches. It is untrusted for semantic correctness and completeness. A built-in slow producer can emit a complete evaluation derivation for every admitted construct. Both producers satisfy the same internal producer interface; neither can mint checked tokens. This is a real seam because there are at least two implementations, and producer changes cannot alter the public checking relation.

The checker has a fixed finite rule set. It walks the admitted program or checks an admission-derived obligation manifest whose completeness is proved. It checks typed reads, legal simultaneous effects, exact result/error derivations, every applicable obligation and all required authenticated state/view changes. It returns a private checked transition only after the whole derivation is accepted. Generic extension hooks that accept a new summary law at runtime are excluded: a new checker rule is a new reviewed/proved release.

State is an immutable authenticated ordered map of typed entity keys and values, plus a permanent used-ID set, lineage metadata and semantic views. Views include exact type membership, reverse references, approved ordered query indexes and obligation summaries. A view has an explicit defining equality, version and root. Indexes are implementation data, not new business state. Unneeded acceleration indexes can be discarded and rebuilt; any index used as a proof premise must be committed and semantically justified.

The storage seam has two actual adapters:

| Adapter | Required behavior and trust |
|---|---|
| `Repository::memory()` | Immutable content-addressed nodes, exact atomic in-process CAS, deterministic request-result lookup. Useful for tests and ephemeral use; makes no process-crash durability promise. It uses the same checker and proof semantics, not an acceptance shortcut. |
| `Repository::durable(path)` | Durable immutable objects, transactional exact-head CAS plus request-result/outbox/root publication, recoverable intents, reachability retention and exact status lookup. Its specified filesystem/database assumptions are trusted for availability, durability and serialization. Hashes authenticate node bytes; they do not repair a stale authoritative head or a lying CAS implementation. |

The adapter's trusted control operations are small and explicit: `read_current`, `stage_objects`, `flush_objects`, `compare_publish(expected, manifest, request_result, outbox)`, `lookup_request`, and `recover`. Bulk object reads may be hostile: the checker validates type, encoding, length and digest against the accepted root. A durable database adapter can implement these control operations with a transaction; a filesystem adapter needs its own checked journal/root-switch protocol. They are alternative implementations of one contract, not interchangeable durability guarantees. [VeriBetrKV](https://www.usenix.org/system/files/osdi20-hance.pdf) is a precedent for proving storage refinement; its disk model is not adversarial-server authentication and its proof does not transfer to a new adapter.

The proof backend is an internal release choice. Ordinary callers do not select curves or load key files. Deployment operators install one exact recipe and the module reports its costs. Allowing a pluggable proof backend without proving it implements the same public relation would make the seam fictitious.

## The exact common relation

Let `Ω = (live typed state, permanent used identities, exact lineage/history, active declarations)` and let `V` contain all semantic views. Let `F_M(Ω, I, C)` be the exact deterministic Core transition result, including selected errors, simultaneous effects, commands with multiplicity and promised observations. Let `J_M(Ω,V)` state **equality** of every view with its declared function, not merely satisfaction of selected safety predicates.

The public proof state is a versioned tuple:

```text
Z = (lineage, genesis/adoption claim,
     program, schema, complete policy activation, semantics, evidence profile,
     checker program and circuit release,
     state root, used-ID root, view roots,
     committed position, exact event head, event-log root/length,
     ordered output/command root and retention-contract identity)
```

`Valid(Z,Ω,V)` means that the encodings/commitments represent exactly those values, the program is admitted, the policy set is the complete one selected by the trusted deployment rule at that coordinate, and `J` holds. Input/context/request commitments and exact outcome/effect/observation commitments enter each attempt relation. Full digests use constrained bits or enough range-constrained limbs for an injective representation; field reduction is not digest binding. Every encoding is typed, length-delimited, domain-separated and versioned.

`K(Z, I, C, result, Z', witness)` accepts only a derivation satisfying:

```text
Valid(Z, Ω, V) ∧ K(...)=accept
  ⇒ result = F_M(Ω,I,C)
     ∧ Valid(Z', Ω', V')
     ∧ exact_event_and_output_update(Z,I,C,result,Z')
```

For refusal/error, `Ω'=Ω` and committed history is unchanged. A separate `AttemptClaim` binds the selected outcome without pretending the attempt entered the committed log. A command-only allowed transition advances event/history/output coordinates even when its state root does not change. Attempt counts, event counts and proof microsteps are distinct typed coordinates.

### Coverage, absence and global meaning

The checker cannot accept a producer's assertion that its dependency list is complete. It derives conservative footprints from the complete admitted syntax and checks updates through fixed view laws. A manifest generated during admission is acceptable only with a theorem/checking certificate that it enumerates every action, effect, rule and relevant subject. Unknown affectedness is treated as affected.

* A point read proves the typed value or nonmembership at the exact accepted root. Creates check permanent-ID nonmembership as well as live-state absence. Removal does not erase the used-ID fact.
* A range answer opens a contiguous ordered interval, authenticated neighbors/endpoints, its covered subtrees and count/order metadata. Empty ranges need the same gap evidence. A list of individually authentic rows is not complete. The [Merkle B-tree paper](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf) supplies this distinction for its indexed query class, not for arbitrary Core predicates.
* A reverse-reference index equals **all** incoming typed edges. Initialization and every reference-changing effect establish this equality. Target removal checks the complete resulting incoming range; simultaneous deletion/retargeting uses Core's simultaneous-effect rule.
* A cached count or aggregate is accepted only under a proved leaf-to-summary equality and complete maintenance delta. Authentication of a stale sum is insufficient. [Authenticated aggregation research](https://www.cs.bu.edu/~reyzin/papers/auth-db-agg.pdf) gives query structures under endorsed data; proving their correspondence to every Core update remains this design's obligation.
* An arbitrary predicate unsupported by a cheap index uses a complete canonical type range and evaluates every candidate through the same checker calculus. Broad dependency invalidation may visit all subjects. That is full semantic coverage with high cost, not a hidden unsupported case.
* Query dependencies include absence intervals, the type universe and captures that could admit new members. An insertion into an empty result therefore invalidates it. Capture changes may invalidate all subjects. Reverse dependencies are themselves exact maintained views; accepting a hash of an incomplete dependency index would break the induction.
* Global constraints use a complete ordered obligation partition. Unchanged obligation results can be framed only under checked footprint and exact-parent premises. Changed obligations must be evaluated or updated with an applicable fixed summary law. The checker derives the selected first failure from the entire relevant ordered partition, never from a producer-selected set of successes.

The basic count example has a small witness: authenticate fresh identity and changed leaf paths, establish one distinct creation, update exact cardinality by one, check the new local rule, frame unaffected obligations and derive the genuine cap outcome. Creation 1000 and refusal 1001 must follow the same rule. This example establishes neither cheap arbitrary globals nor unlimited lifetime identity capacity.

### Exact errors, laziness, effects and commands

Each evaluation derivation carries program position, bindings and an ordered outcome. Arithmetic uses the exact checked signed domains and rounding rules. A lazy rule contains the deciding branch derivation and no evaluation claim for a skipped branch. Reordering independent work is allowed only if the final ordered result/error/trace is proved identical.

An ordinary mathematical sum is not a valid replacement for a checked ordered fold. A total, representability-proved fragment can use a certified summary law; otherwise the checker evaluates the canonical sequence. A future prefix-summary law must prove all intermediate-overflow/first-error behavior, not just the final integer. This intentionally sacrifices locality where no suitable law exists.

Effect checking binds the full action, alias restrictions and all simultaneously realized assignments/creations/removals. No “safe but different” poststate is accepted. Command occurrences are emitted according to the exact canonical command contract with positions and multiplicity. Equal payloads remain separate occurrences. A proof of a state invariant does not determine commands, and a valid command root cannot be attached to an unrelated transition.

## A versioned evidence contract is necessary

The candidate chooses a new, explicitly versioned event/evidence profile. Its authoritative state/history identity uses authenticated typed roots and a canonical event header committing to parent, input/context, outcome, effects, complete observation support and canonical command sequence. It does not silently reuse Core's old MuHash/expanded-JSON event identifiers. Persistent tree shape is either canonical or its semantic meaning is proved independent of representation; that choice is part of the profile, not left to a producer.

For each event, `Expand(program, parent, input, context, compact support)` reconstructs the complete promised semantic observations, traces and command data. The theorem must relate expansion to the reference result, including errors/order. Retained original inputs, deltas and shared evidence permit reconstruction without trusting the producer's renderer. Routine certification commits to this structured meaning; it does not flatten an expanded record to hash it on every update.

Published old-profile artifacts retain their exact algorithms and verifier requirements. Importing an old lineage needs a one-time checked adoption proof that actually verifies its old prefix/identities and produces the new initial anchor. The old-history work is charged to adoption. An old StateId beside a new root is not a bridge. If identical old canonical IDs are demanded for every new event, canonical rendering/SHA and MuHash correspondence must instead be constrained within every step; that comparator retains its byte and non-native-arithmetic costs. It is not the selected low-cost design.

A full legacy-shaped audit export can still be offered with explicit version/identity annotations. It necessarily retrieves/reconstructs and writes the requested bytes. New command occurrence IDs derive from the new event identity; old IDs are preserved in old segments with an explicit adoption mapping, not relabeled as identical.

## One proof chain from initialization to a fresh consumer

The following are required artifacts, not supplied theorems. The proposed release is not acceptable if any of them is replaced by testing alone.

1. **Exact reference semantics.** Define the whole admitted Core language, admission, decoding, arithmetic, lazy/error order, effects, reference/lifetime rules and complete observations in a proof assistant. Establish correspondence to the intended Core contract and freeze the version. Differential and hostile tests against actual Core are essential validation but cannot establish this universal theorem. If legacy decoder implementation behavior is part of the requested compatibility promise, formalize/refine it explicitly; the array-trace counterexample from investigation 9 must survive.
2. **Initialization.** Define an executable initialization checker. Empty genesis proves complete empty state/used-ID/views and its initial history. An import supplies a complete authoritative inventory and, where historical legality is claimed, lifetime/history support. The checker enumerates it, validates it, builds/checks every J equality and binds the exact genesis/adoption root. An unsigned producer snapshot cannot prove that an omitted historical identity never existed. Without prior lineage evidence the import can define a new trusted genesis, but cannot certify a previous history.
3. **Semantic checker.** Prove `K_sound`, honest-derivation completeness, and init/rebuild correctness over the full reference semantics. Prove framing, every view law, conservative affectedness and obligation coverage. Completeness is an existence result for a terminating finite execution; resource caps can still reject operationally. A full-scan derivation must exist for difficult constructs and must be inside K, not an unproved native fallback.
4. **Executable native checker.** Define K and its bounded parser/encoder in a first-order executable formal subset. A concrete route is HOL4 definitions translated and compiled through CakeML, following the verified-checker precedent. Prove the generated machine code refines K under stated runtime/FFI/memory assumptions, including parsing and failure outcomes. The host wrapper accepts a checked result only from this installed checker and binds the exact byte inputs/outputs; the wrapper/FFI and storage control protocol need their own refinement or remain named trust assumptions. Merely extracting a model to unverified Rust would leave the existing 032 correspondence gap.
5. **Checker-machine and circuit correspondence.** Specify a small checker machine executing that same formal K program. Its state contains control position, authenticated checker/program memory, roots and pending obligation frontier. Prove machine execution refines K. Construct a verified compiler or a proof-producing circuit generator with a kernel-checked validator, establishing that satisfying the **actual emitted** fixed-step circuit is equivalent to a machine microstep, including Boolean/range constraints, SHA/encoding and authenticated accesses. Bind the actual loaded constraint matrices/shape to the checked artifact. A theorem about an abstract R1CS relation plus an unverified Bellman generator does not discharge this requirement.
6. **Finalized semantic steps.** Permit variable numbers of checker-machine microsteps, but close an event only from a `Done` state where all obligations, memory/view updates and output/header hashes are checked. Proof state includes phase, logical event count and microstep count. A prefix ending inside a lazy expression, before an obligation, or before output finalization is not a certified event. Initialization can use many such microsteps with its own checked closing rule.
7. **Accumulation and compression.** Prove/use the selected backend's soundness for the exact emitted relation, bind expected initial state, logical endpoint, microstep count and returned final state, and verify a cryptographically compressed final certificate. The consumer checks the checker-program/circuit release and exact expected subject. The implementation of the cryptographic verifier and hash/arithmetic primitives remains an explicit assurance obligation; proof-system security assumptions are not kernel proofs that the primitives are secure.
8. **History induction and release transitions.** Prove that Init followed by finalized accepted K steps establishes exact F execution, J, state/history/output commitments for the entire claimed prefix. A release/module/policy change or migration is an explicit certified transition from outgoing to incoming meaning, with both subjects and authorized activation. A shared schema or circuit label cannot substitute for that theorem. A certificate beginning at a trusted checkpoint proves only that continuation unless its initialization certificate recursively binds the earlier chain.

The existing 032 Lean results can inform specification and adversarial cases, but they do not instantiate this chain. A CakeML route introduces a HOL4 formalization/porting obligation; it does not inherit a Lean theorem merely because the names match. If implementation cost makes verified compilation/circuit validation infeasible, the report must state the remaining trusted translation and downgrade the end-to-end claim accordingly.

The resulting conditional theorem is:

```text
trusted expected deployment/genesis + InitSound
 + KRefinesExactCore + Native/Circuit/EncodingCorrespondence
 + commitment binding + selected proof-system soundness
 + VerifyCompressed(expected Z0, expected Zn, certificate)
 ⇒ existence of the exact Core-valid committed prefix from Z0 to Zn,
   the exact bound command/observation stream, and J at Zn.
```

It proves computation under the declared inputs. It does not establish fresh external authority, physical command execution or retrievability. Those remain separately stated contracts.

### Fresh historical verification without a replay bridge

A portable certificate contains the compressed initialization/transition proof, claim header, release/parameter identities and any selected event/output inclusion/range proof. A fresh consumer installs its independently selected checked release, establishes its trust anchor and verifies the exact expected endpoint. It needs neither a Core Store nor full history replay, nor the producer's prior acceptance. The reference-semantics, state/header and observation binding lives **inside the certified relation**. This is the decisive difference from 032's Nova plus full Core bridge.

Verifying an expected log head proves that exact certified prefix, not that it is the globally latest or uniquely authoritative fork. Freshness and canonical head selection come from a pinned/checkpointed expected head, an authorized head signer/consensus system, or the trusted local repository control contract. The verifier must report that anchor choice; an untrusted server can otherwise replay an old valid certificate.

Event inclusion and append-consistency proofs permit selected command pages and continuation checks, but do not prove semantics on their own. [RFC 9162's Merkle consistency construction](https://www.rfc-editor.org/rfc/rfc9162.html#section-2.1.4) is a structural precedent; this design adds certified event semantics and exact lengths/positions. A selected output proof must show its complete requested range and occurrence ordering, including an empty range, rather than merely include a few real commands.

## Proof backend and parameter lifecycle

The concrete first comparator is **Nova accumulation with cryptographic compression**, not a claim that the actual 032 RecursiveSNARK already meets the historical interface. The selected deployed backend would be fixed only after the following same-relation comparison:

| Choice | Reason to consider it | Cost/assumption that prevents treating it as a checkbox |
|---|---|---|
| Pallas/Vesta, Pedersen/IPA, Spartan compressed proof | Closest to the actual Core032 path; avoids introducing a universal powers-of-tau setup. | Compression setup/proving/verification must actually be implemented and measured. Ordinary Spartan verification can depend on step-circuit size; SHA/authenticated-memory checker microsteps may dominate proving. No measured millisecond Core result exists. |
| Preprocessed compression such as MicroSpartan | Candidate where fresh verifier cost is dominated by the checker circuit size. | Pays circuit-specific preprocessing, proving/verifier key storage, loading, identity validation and update/recovery costs. Must compare end-to-end production plus fresh verification, not only verifier arithmetic. |
| HyperKZG/Mercury-based Nova configurations | Candidate when small fresh proof checks justify pairing-based commitments. | Introduces a universal setup and associated provenance/degree/security requirements; changes curves, implementation and key lifecycle. It is a different audited release, not a runtime switch that inherits IPA evidence. |
| Compiled-guest/zkVM proof of K | Comparator if a maintained backend yields a simpler executable/circuit correspondence route. | Proves the specified guest image, not Core meaning automatically; authenticated external reads, init, recursion/compression and guest/compiler correspondence remain. It may execute more instructions than the direct checker circuit. |

The pinned [Nova README](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/README.md) distinguishes these commitment/compression/preprocessing choices. The [pinned implementation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/nova/mod.rs) separately exposes setup, recursive proving/verification and compressed proving/verification. Selecting a type used for a parameter-size hint does not produce a compressed certificate.

A release manifest fixes proof-system revision, curve/security assumptions, checker-machine program, circuit shape, encodings, capacity/limb/step bounds, compression recipe and setup provenance. Build-time checking binds the actual matrices/program and semantic correspondence artifacts. Parameters/keys are independently derived or matched against authenticated consumer-selected recipe/artifacts. A producer-provided key is never sufficient.

First install charges derivation/preprocessing or validated key transfer. Each cold process charges necessary reads, decoding and identity checks. A resident process can reuse immutable validated keys, but this is measured amortization with declared lifetime/memory, not prior proof acceptance. Every new certificate is verified. Release/circuit changes produce new identities and explicit segment-transition checks. Corrupt/partial keys are rejected; recovery rederives/refetches and charges that cost. No long-lived cache may cross a different subject/recipe implicitly.

The honest baseline is substantial: [Core032's measured lifecycle](../sources/core/specs/032-transition-verification-study/evidence/cost-model.md) has a 68.818 s first-use C1/H2 producer+consumer median and a separately measured 22.487 s reuse median. Reuse still loads/validates parameters at about 9.6 s per process. The C1 raw recursive proof is 5,385,450 bytes and parameters 34,457,029 bytes; compression is `NotImplemented`. Its isolated H1/H2/H8 verification times are 0.472/1.226/2.249 s. These finite measurements are neither a constant-time result nor a lower bound on a new compressed implementation. Synchronous certification must include its actual compression and final verification costs before any millisecond claim.

## Durable atomic publication and recovery

Cryptographic validity proves a candidate derivation. Only the repository's authorized exact-parent publication selects the canonical next event. The default protocol is:

1. Read current certified head and deployment activation; resolve an existing request ID before doing new work. Authenticate required parent objects. Evaluate/propose and independently check the complete transition without mutating canonical views or outbox.
2. Construct immutable event/support/state/view/output nodes, a candidate request-result mapping and a recoverable publication intent. Hash/check them and stage them under content addresses. For an allowed result, construct the extension from the exact parent's proof state, compress and independently verify it against the exact candidate head. A branch proof is not yet a committed event.
3. Make all required objects and the verified certificate durable under the adapter contract. The manifest commits the required support closure/retention policy. Validate all new references before the root switch; retained references inherit the prior head's checked durable closure and pins. This requires an inductive storage invariant, rather than traversing the entire old object graph at every commit. Do not publish a head referring to an unstaged proof or required node. This is a local publication guarantee, not a promise that remote storage will remain available forever.
4. Atomically compare the full expected parent/history and activation coordinate, then publish the new head, request-result mapping, required retention pins and canonical command outbox references. A transactional adapter commits these together. A filesystem adapter must prove its equivalent journal/root-switch/recovery protocol; an atomic rename alone does not establish all referenced-data durability.
5. On CAS conflict publish nothing from the losing candidate. Its proof is valid for a noncanonical branch, its nodes can later be collected, and its native/view/prover scratch state never becomes the next canonical state. Return `Conflict`. Do not extend the canonical accumulator with a losing branch.
6. Acknowledge only after the durable publication point. If the acknowledgement is lost, lookup by exact request ID/request digest returns the original event, time/context, certificate and command occurrence IDs. The host drains the durable outbox by occurrence ID. Replay does not dispatch; exactly-once physical execution additionally needs the host's durable acknowledgement/deduplication protocol.

For a semantic refusal/error, publish at most the immutable attempt certificate/request-result entry, atomically tied to its checked parent and without moving the committed head or command outbox. A concurrent head change can cause a conflict rather than publishing a result as though evaluated at the new parent.

Recovery distinguishes durable intent, staged objects and canonical manifest. Before root publication it returns the previous head and completes/abandons the intent safely. After root publication it restores that exact committed result even if no acknowledgement was sent. Partial/corrupt proof files are never promoted. Losing a disposable prover accumulator does not invalidate an existing compressed certificate; continuation must restore a checked proving checkpoint at the exact head or replay retained witnesses to rebuild it, with that recovery cost reported. If checkpoint recovery cannot establish the exact head it blocks new certified publication; it does not use an unverified fold counter.

An uncertain commit needs **positive or negative resolution under the authoritative control contract**. Finding the exact request mapping proves original publication. Proving absence needs an authenticated nonmembership answer at a trusted fresh serialized repository head, or the equivalent linearizable transaction result, and a recovery rule for any pending intent. An unauthenticated “not found,” stale replica or network timeout cannot authorize retry as a new event. A Merkle proof at an old valid root proves absence only at that old root.

Two progress coordinates remain separate even in the synchronous design: `native_checked_candidate` means K accepted a candidate; `verified_certificate` means compressed verification accepted its exact claim. Neither is a canonical head until CAS succeeds. The reported committed native and cryptographically verified frontiers coincide at each successful acknowledgement by contract. During preparation, status must not display a constructed fold as certified progress. This candidate exposes no default asynchronous success mode; any later native-first variant must add explicit native/verified heads, lag/backlog, admission/backpressure and command-delivery rules to its interface.

## Retention, authority and data availability

The deployment trust anchor establishes which program/policy activation rules and genesis are authorized. K verifies exact declared activation/authorization evidence where expressible, and binds it into each event. A signed policy hash does not prove that the complete applicable policy set was chosen. External authority selection, truthful context and current authorization remain explicit host/governance premises. Proof validity does not approve a deployment, alter a Safety Model or authorize a physical action.

Retention pins the information required by each promised operation:

| Promise | Retained information |
|---|---|
| Fresh semantic-prefix verification | Compressed proof, exact expected claim/anchor, independently trusted release/keys and any selected output proofs. No full history requirement. |
| Continue execution | Current authenticated state, used IDs, semantic view roots and reachable data, admitted declarations/context rules, plus a validated prover continuation checkpoint or sufficient rebuild support. |
| Re-evaluate/export/replay | Genesis/adoption support, ordered events/deltas, original requests/context, applicable releases/policies and sufficient observation support to reconstruct every promised field. |
| Replay commands | Exact event-linked canonical occurrences/payloads/order/multiplicity; host delivery acknowledgements belong to its outbox protocol. |
| Full historical data audit/first divergence | Complete selected historical support and comparison/reference material. A succinct validity proof alone cannot report the first unavailable/corrupt object or compare an alternative trace. |

Garbage collection follows all published retention pins, current/older certified heads, command delivery needs and active exports. Pruning past the promised retention contract is an explicit contract change. The permanent used-ID set may grow after live data removal; bounded live population is not bounded lifetime memory or proof capacity.

`verify` may succeed while `audit` reports missing data. That is neither semantic corruption nor proof invalidity. `audit` traverses the promised history/support in canonical order, reconstructs outputs and reports the first actual mismatch/availability failure. Its bytes and traversal are charged to audit. It must preserve the old corruption-detection promise for old profiles; new proof-only verification is a separately named interface and does not silently replace full replay. Continued operation after data loss requires authenticated retrieval or a checked rebuild from sufficient retained authority. A certificate cannot reconstruct missing row values by itself.

## Costs, locality conditions and falsification

Use `N` live entities, `U` lifetime identities, `H` events, `D` actual affected semantic obligations, `A` authenticated paths/nodes opened, `B` requested expanded bytes, `K` checker-machine microsteps and `S` circuit size. An input changing one row does not imply small D. The candidate's proposed eligible update is native execution plus K checking over affected derivations and opened paths, new-object construction, proof production/compression/verification and durable publication. It is not a universal `O(log N)` transaction claim.

| Scenario | Charged work and conditional limit |
|---|---|
| Empty deployment first use | Admission/correspondence artifacts, parameter setup/preprocessing/load, empty init proof/compression/verification and durable creation. N=0 removes state ingestion, not those costs. |
| Arbitrary initial import | Read/validate complete authoritative content, lifetime/history where claimed, build/check J and commitments, produce init/adoption proof, persist support. Under a byte-access model, consuming previously unauthenticated B bytes costs Ω(B); arbitrary initial validity can require inspecting all N. A certified existing root changes the access premise, not the size of the original ingestion. |
| Cold open of certified persisted state | Verify exact certificate/subject/keys, restore root handles, retrieve/authenticate needed continuation nodes/checkpoint. It need not read all N merely to accept a previously certified root, but full local hydration costs the fetched bytes and rebuilding lost J/indexes needs complete supporting data. Cold key checks and recovery are not excluded. |
| Eligible ordinary action | Small affected set, complete fixed view laws, bounded command/output sizes and maintained authenticated indexes permit checking roughly changed paths plus D work; balanced-tree point paths have logarithmic depth under their proved shape invariant. Proof cost tracks K/S, hash work and final compression. Network/durable latency and contention remain. |
| Global/capture/fanout action | Arbitrary predicate changes, high reverse-reference fanout, a new global rule or unproved ordered partial aggregate can force Θ(N) work or worse query joins. Full-scan derivations preserve semantics; their cost counts against the common-workload ambition. |
| Fresh independent history check | Expected-subject/authority/key setup + compressed verification + selected output proofs/transfer. Intended independence from H concerns semantic-prefix validation after the exact relation is implemented, not key size, output size or data audit. Measure it; do not infer it from constant serialized proof bytes. |
| Full audit/export | Retrieve and authenticate support, reconstruct/check relevant observations, write B bytes; Ω(B) output is unavoidable under that contract. Full data integrity inspection is not made constant by a proof. |

A point-read access model can justify opening only needed nodes of an already certified root; an access model demanding all imported bytes, a fresh latest-head guarantee or a full historical audit cannot. Declare the access model with each latency. No source-backed universal minimum proves that every cold start must scan all N; no certificate makes first ingestion of arbitrary unauthenticated state free.

A decisive future evaluation uses the identical complete claim across this candidate, the direct-kernel alternative and the incremental-compiler alternative. Freeze absolute budgets and environment before collection; compare against investigation 12's compatible implementation as well as the forced-full semantic reference. No such evaluation was run here.

The candidate is falsified or needs redesign if any of these occurs:

1. A sparse accepted witness omits a new query member, incoming reference, earlier error, action effect or duplicate command, or accepts a used-ID reuse. Mutate actual acceptance paths, including an output that is safe but semantically wrong.
2. The formal proof stops at logical K/R1CS while actual executable parsing, emitted circuit matrices, SHA/limb encoding or public output binding is unconnected. That repeats the 032 limitation rather than closing it.
3. Init/recovery trusts a producer-selected complete snapshot/index or a checkpoint without a checked origin; module/policy changes inherit old J without transition validation.
4. Fresh verification requires full Core replay to bridge event/state/observation identities. That defeats the selected historical interface. An explicit one-time old-profile adoption remains charged separately.
5. Ordinary certification time, cold setup/recovery, proof memory or compression is too large, or the full-scan producer is frequent enough that the promised common workload misses its absolute budget. A fast native checker with a slow certified receipt is a failed ordinary-path result here.
6. Durable crash/CAS/lost-ack controls produce an orphan published root, missing required support, duplicated commands or a certificate for a losing branch presented as canonical. “Proof verified” alone is not a durability test.

The smallest useful discriminators include the real 1000/1001 cap, remove/reuse, simultaneous references, empty-to-nonempty query, changed capture, checked intermediate overflow, lazy skipped error, first-error ordering, command-only events and equal duplicate commands. Measure N/U/H independently, high fanout, first install, resident operation, cold certified open, total init/adoption, compression, fresh verification, full export and prover-checkpoint loss. Report whole-sample totals and cumulative lifecycle work; never add separately sampled phase medians or hide allocator preparation, witness production, key loading, persistence or final verification outside the claimed interval.

This candidate offers the ordinary caller strong leverage and concentrates semantic assurance in one fixed checker. Its price is the substantial engineering/proof obligation for that checker, its executable/circuit correspondence and synchronous cryptography. Those costs are the selection question, not details that can be deferred while calling the architecture a millisecond solution.
