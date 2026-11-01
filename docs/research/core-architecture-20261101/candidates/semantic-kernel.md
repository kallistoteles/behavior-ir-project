# Candidate 1: Core as a fixed semantic derivation machine

2026-11-01. Architecture proposal, not an implementation, proved theorem or measured latency result. This candidate deliberately starts with a **fixed full-language semantic machine**, rather than a configurable incremental compiler or a public producer/checker protocol. The machine executes ordinary requests, preserves justified derivations and produces its own history evidence. Callers neither construct plans nor supply semantic witnesses. Three entrypoints hide that work: `establish`, `perform`, `examine`.

The hypothesis is that one rule-defined machine can be both the execution model and the computation being attested. A persistent derivation structure permits exact reuse; a proof of that machine's execution permits independent prefix checking. This may reduce the number of separately implemented semantic bridges. It does not follow that a small kernel is fast, that proving the machine is cheap, or that this composition is better than the other candidates.

## Reviewed evidence and what it permits

The [inventory](../../investigation-map.md) defines the thirteen investigations. I read the following primary local reports, including the complete required contracts, rather than infer their scope from their titles. Supporting source snapshots, all raw samples and every subordinate proof file were **not** independently replayed or exhaustively re-audited. No build, test or new measurement was run for this proposal.

| Investigation | Reviewed source coverage | Constraint carried into this design |
|---|---|---|
| 1, Core029 | [Complete incremental-validation documentation](../sources/core/docs/incremental-validation.md), [complete evaluation report](../sources/core/specs/029-incremental-global-validation/evaluation-report.md) | Existing checked reuse is real but narrow; it still emits full evidence. Exact parent, full admitted metadata, context and successful CAS matter. |
| 2, Core031 | [Complete investigation](../sources/core/specs/031-scalable-execution-evidence/investigation.md) | N, H, affected computation and output bytes are different cost axes; finite-map arithmetic alone is not an optimized Core checker. |
| 3, single creation | [Complete profile report](../sources/core/specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md) | A new small row produced 4,085,191 decision bytes at N8192; 79% was trace. Avoiding predicate work does not avoid this representation. |
| 4, architecture/authentication | [Complete options](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/architecture-options.md), [complete authenticated-structures review](../sources/core/specs/031-scalable-execution-evidence/profiling/architecture-options-20261028/authenticated-structures.md) | A DAG is a layout; authenticated reads, semantic reuse, query completeness and crash-safe publication require different arguments. |
| 5, first principles | Complete [research](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md), [derived architectures](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/derived-architectures.md), [obligations and limits](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/obligations-and-limits.md) | Start with exact F and maintained meaning J; do not equate safety, computation, authority, identity or reconstruction. |
| 6, greenfield/composition | Complete [research](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md), [composition findings](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md) | A broad interpreter is a legitimate comparator. Proof steps, initial memory, observation binding, proof closure and code correspondence must all count. |
| 7, Core032 | Complete [investigation](../sources/core/specs/032-transition-verification-study/investigation.md), [transition contract](../sources/core/specs/032-transition-verification-study/contracts/transition-contract.md), [proof/evidence contract](../sources/core/specs/032-transition-verification-study/contracts/proof-and-evidence.md), [trust ledger](../sources/core/specs/032-transition-verification-study/evidence/correspondence.md), [batch-checker correspondence](../sources/core/specs/032-transition-verification-study/evidence/batch-checker-correspondence.md), [circuit correspondence](../sources/core/specs/032-transition-verification-study/evidence/circuit-correspondence.md) | A recomputed complete J, whole-history replay checker and tiny Nova circuit did not implement this candidate. Restricted logical theorems are not implementation proofs. |
| 8, strict decoding | [Complete report](../../core-continuation-20261029/report.md) | Decode once at a real ingress; do not let duplicate keys disappear before checking them. |
| 9, typed records | [Complete report](../../core-typed-record-20261031/report.md) | Accepted array forms and selected parser errors are observable; typed equivalence cannot be assumed. |
| 10, residual/serialization | [Complete report](../../core-residual-profile-20261031/report.md) | Changing allocation history changes later costs; include the first real export and full operation history. |
| 11, bundle ownership | [Complete report](../../core-bundle-ownership-20261031/report.md) | Removing one clone is useful evidence but not a new computational architecture. |
| 12, combined optimization | [Complete final report](../../core-final-investigation-20261031/report.md) | Measured 22–31% consumer improvements preserve the population-sized record. Those results are not millisecond evidence for a new machine. |
| 13, reassessment | Complete [scope](../../core-redesign-reassessment-20261101/scope.md), [prior evidence](../../core-redesign-reassessment-20261101/prior-design-evidence.md), [researched alternatives](../../core-redesign-reassessment-20261101/researched-alternatives.md) | Startup, transitions and independent history checking form one costed and justified chain. No earlier prototype selects a hybrid or rules out a different latency regime. |

Additional inspected contract: the relevant state, publication, lifecycle, query, migration and read sections of [persistence.md](../sources/core/docs/persistence.md), and the [current supported engine surface](../sources/core/api/engine-surface.txt). The candidate is a future interface, not a claim that this existing surface already has only three methods.

## Required meaning before representation

Let `m` be the complete admitted module, including metadata relevant to admission or observations; `p` the exact semantic/evidence profile; and `c` the supplied context with its declared external-authority assumptions. Define:

```text
Ω = (live typed values, permanent used-ID inventory, exact lineage/history,
     active module/schema/profile and their activation history)
F(m,p,Ω,request,c) =
  (selected semantic outcome/error, candidate Ω', ordered command occurrences,
   complete normative observation)
```

The observation includes phases, lazy skips, canonical subject/rule order, checked arithmetic and error precedence. Simultaneous effects are interpreted as Core specifies, rather than converted into arbitrary sequential writes. Reads, refusals and evaluation errors need not advance committed history. An allowed command-only event does advance history. If denied attempts are attested, their attempt transcript is separate from committed history. A proof of the committed prefix does not cover an unrecorded refused attempt. These requirements come directly from the [032 exact transition contract](../sources/core/specs/032-transition-verification-study/contracts/transition-contract.md).

The machine state is `(Ω,D)`. `D` is a persistent collection of evaluation derivations, observation expressions, indexes and coverage information. It is derived information with an explicit meaning:

```text
J(m,p,Ω,D) :=
  every reused derivation denotes the exact evaluation for its complete environment;
  every maintained collection/view equals its defining function over Ω;
  every coverage/dependency index contains all required obligations and invalidations;
  every observation expression expands to the promised ordered observation;
  every authoritative and derived root encodes the values its type claims.
```

The third conjunct is essential. An accurate result cache paired with an incomplete invalidation index is unsound. Equality of live `StateId`, equal position, equal count, or equal behavior hash with different admitted metadata does not imply equal operational inputs. Removed identities and command-only events give concrete counterexamples. [First-principles Ω/J analysis](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md).

Hard requirements are exact F; justified initialization and preservation of J; complete language execution; exact-parent publication; independent prefix verification of the same F/J machine; original-event recovery; explicit authority and availability findings; and complete phase costs. None can be replaced by a hash or a local private type.

## The external interface

The module is `Core`. Its external seam is a checked semantic session and independent examination of published claims. This has Depth because callers no longer coordinate admission, snapshots, evaluation, reproduction, view promotion, proof construction, publication and replay. Their work is submitting a request at an expected parent and choosing the observation they need.

Illustrative types describe obligations, not Rust ready for implementation:

```rust
// Opaque process-local authority: no public/deserializing constructor.
struct Session;

struct Subject {
    lineage: LineageId,
    committed: ExactHistoryRef,       // includes exact record, not just StateId
    module: CompleteAdmittedModuleId,
    schema: SchemaId,
    semantics: SemanticProfileId,
    evidence: EvidenceProfileId,
    kernel: KernelIdentity,
}

enum Origin {
    New { module: Bytes, seed: Bytes, genesis: GenesisInputs },
    Resume { expected: Subject, publication_key: Option<PublicationKey> },
    Import { expected: Subject, package: UntrustedPackage },
}

struct Environment {
    storage: LocalStorage,            // real memory or durable adapter
    authority: AcceptedAuthority,    // supplied outside the evidence package
    limits: ResourceLimits,
    guarantee: Guarantee,
}
enum Guarantee {
    Native,                          // exact local execution; no succinct promise
    Attested,                        // proof closed and checked before success
}

fn establish(origin: Origin, env: Environment)
  -> Result<Established { session: Session, subject: Subject,
                          initialization: Findings }, EstablishFailure>;

struct Attempt {
    parent: Subject,
    request: Request,                // admitted action/read/invocation or lifecycle request
    context: ExplicitContext,
    publication: PublicationIntent, // inspect only, or publish with stable retry identity
}
fn perform(session: &mut Session, attempt: Attempt)
  -> Result<Execution { outcome: ExactSemanticOutcome,
                        publication: PublicationFinding,
                        evidence: EvidenceReference,
                        commands: OrderedOccurrences,
                        subject: Subject }, OperationalFailure>;

struct Examination {
    expected: ExpectedClaim,         // exact anchor, endpoint, profiles and claim scope
    projection: Projection,         // receipt, state, command interval, or full audit
    inspect_retained_data: DataAuditScope,
}
fn examine(claim: Examination, source: UntrustedEvidenceSource,
           authority: AcceptedAuthority, limits: ResourceLimits)
  -> Result<ExaminationReport { semantics: ValidityFinding,
                               provenance: AuthorityFinding,
                               availability: AvailabilityFinding,
                               output: ProjectionStream }, ExaminationFailure>;
```

`Request` is the existing domain request family, not an extensible plan/witness language. Migration and module activation are explicit domain requests with checked source/target semantics. `PublicationIntent::Inspect` covers read-only evaluation and declined publication; it cannot return an executable commit capability that bypasses a subsequent parent check. A later publish request repeats/reuses computation internally. Original semantic output and original publication metadata are preserved when resolving a retry.

`Projection` names consumer output, not a caller-defined computation engine: receipt, state, ordered command interval, and full audit have distinct established meanings. A command page must prove its interval is complete, including empty intervals. `ProjectionStream` may fail while fetching retained data; prior proof validity remains a separate finding. A consumer requiring a completed full audit accepts only after the stream and required checks finish.

### What callers must know

1. `establish` is the only way to obtain a session. All imported packages are untrusted data. It establishes the exact subject and required J premises; a resumable head with missing working data is not reported as a fully fetched state.
2. `perform` uses the supplied exact parent. It never silently rebases a stale request or substitutes fresh context for an original committed retry. Concurrent sessions may race; only exact successful CAS publishes a child. Inspection/refusal/error does not publish that child.
3. `Native` and `Attested` are different guarantee contracts. The candidate claiming the full three-stage objective must be measured in `Attested`. The native comparator prevents attributing proving overhead to semantic execution. There is no silent asynchronous proof queue in `Attested` success.
4. `examine` runs in a fresh independent process without session authority. It checks its independently expected claim, installed kernel/profile/key identity and proof; it does not trust producer-created `Session`, `Checked`, roots, keys or prior acceptance. An accepted checkpoint proves only its declared segment unless its certificate reaches the required genesis.
5. Command occurrence identifiers are per exact committed event and ordered index. The module returns intents; physical dispatch remains the host's occurrence/deduplication contract.

The errors belong to different channels:

| Channel | Examples | Meaning |
|---|---|---|
| Semantic outcome | ALLOW, exact refusal, selected evaluation/binding error | Exact F result, including its original phase/order; never fabricated from checking failure. |
| Publication finding | NotRequested, Committed(exact event), Conflict(actual parent), UnknownAck(operation identity) | Atomic publication knowledge, independent of semantic truth. |
| Establish/operational failure | InvalidImport, IncompatibleProfile, UnavailableSupport, CorruptObject, UnauthorizedContext, ResourceLimit, StorageFailure | No permission to treat the attempt as a business denial. |
| Independent finding | Valid/Invalid/Unsupported proof; authority premises; available/missing/corrupt requested support | Valid computation is not current authorization, availability or physical delivery. |

Error ordering within an existing semantic/profile route stays specified. Strict lexical decoding precedes map materialization; old array-form record acceptance and error precedence are reproduced by the corresponding historical interpreter/decoder. New resource limits fail in an operational channel, not in place of an old semantic failure.

`UnknownAck` describes the observer's uncertainty. The physical canonical state is old or new. Until resolution, no new child session authority is installed. Re-entering `establish(Resume { publication_key, ... })` resolves the exact original event from immutable history and returns its original context/time/commands if committed; it never creates another occurrence because live values happen to match. [Core029 promotion rule](../sources/core/docs/incremental-validation.md), [032 publication/recovery contract](../sources/core/specs/032-transition-verification-study/contracts/proof-and-evidence.md).

### Usage

```text
established = establish(New(module, seed, genesis),
                        Environment(memory_or_durable_storage,
                                    accepted_authority, limits, Attested))
event = perform(established.session,
                Attempt(established.subject, create_request, recorded_context,
                        Publish(stable_operation_identity)))

# Different process, independently installed verifier and authority configuration:
report = examine(Examination(expected_genesis_and_exact_event,
                            CommandInterval(lo, hi), RequiredObjects),
                 exported_or_retrievable_evidence, accepted_authority, limits)
```

The same pattern covers removal with surviving references, captured queries, command-only events and full audit output. The caller never promotes a cache or connects a native result to an unrelated proof root.

## Implementation hidden by the interface

The implementation is a fixed, typed abstract machine whose rules interpret the admitted AST and the existing profile-specific semantics. It has ordinary evaluation frames plus a limited set of semantics-preserving rules for persistent collections and derivation reuse. Scheduling is private. Adding a semantic optimization requires proving an additional implementation rule or refining an existing one; a caller cannot install a theorem by registering a new hook.

The machine retains immutable derivation nodes keyed by term identity, complete typed environment, bindings, phase and semantic context. A node contains exact outcome, ordered observation expression and complete dependencies. The fixed `Reuse` rule requires a previous justified node and a proved unchanged/dependency premise. Its conclusion is the same evaluation judgment, not merely an equal final scalar. Hash equality may authenticate a node; the prior derivation and dependency theorem justify its meaning.

To avoid visiting every cached node on every request, the machine maintains a **complete reverse dependency index** and a canonical obligation tree. Their defining equalities are in J. A mutation updates the indexes and visits invalidated obligations, not the complete old tree. Insert/delete/type-membership watches are first-class dependencies: an empty `select` depends on the relevant collection, not on an empty list of positive reads. Unknown dependencies invalidate a conservative region. Context-sensitive nodes include the exact captured context. Changing a capture may invalidate many nodes.

For each entity rule, a generic `ForEach` semantic construct maintains an ordered tree of subject derivations. Creation inserts the new subject, removal deletes it from the resulting-state obligation tree, and changed dependencies replace affected leaves. The annotation combines **the first selected failure and an ordered observation expression**. This composition is associative because it composes specified sequential observations; it is not an unordered conjunction that erases first failure. An unchanged subtree can be retained by its established invariant. A full trace export walks the expression, but a new event does not flatten every unchanged subtree merely to obtain an outcome.

Exact supported collection primitives maintain counts, memberships and reverse references through fixed laws. They are interpretation rules, not module-specific generated delta programs. For arbitrary filters/folds the interpreter can execute the complete prescribed traversal; a broad collection token invalidates that computation when required. Further local reuse is allowed only under its rule's theorem. A checked signed fold cannot be replaced by a mathematical group sum: the former can overflow at an intermediate point. Lazy operands are never evaluated merely to populate a cache. This preserves total language coverage while exposing potentially expensive cases. [Ordered/partial correspondence limits](../sources/core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/derived-architectures.md).

Observation expressions separate stable semantic data from event-specific projection fields. Reusing a derivation in a new event does not reuse an old parent universe, publication time or action binding. A proved projection rule injects the current exact environment. Without that rule, the old node is ineligible. Immutable structured support retains enough information to reproduce full observations, including skipped/error traces. A flat JSON-node transport that still builds every old output first would fail this design.

Authenticated persistent maps and ordered sequences hold authoritative values, used IDs, coverage/index roots, derivations and history/command occurrences. A mutation path verifies old contents and commits the new path; the semantic rules establish why omitted subtrees remain unchanged. RAM consistency or a membership path alone cannot establish query coverage or the correctness of an initial index. Authenticated storage is an implementation of the machine's state, not its semantic argument.

Admission, typing, expression evaluation, derived expressions, rule ordering, lifecycle/alias checks, query execution, command construction, rendering, event identity and proof production are in-process semantics inside this module. They need no external adapter merely because the old code has separate packages. Storage has two actual adapters: memory for logical publication and durable local storage for a stated crash model. That seam is internal to the module's implementation; the caller chooses an installed storage value without implementing semantic callbacks. The durable adapter must demonstrate atomic exact-parent head publication after referenced data is durable. Memory makes no power-loss claim.

External observations and authorization are explicit supplied context plus accepted trust configuration. Core validates the signatures, subject bindings, full applicable policy selection and provenance relations its profile promises. It does not fetch business truth during evaluation or invent a generic clock/network/plugin port. No remote owned dependency is required by this proposal. A future real remote integration can justify its own seam when it exists. This follows the dependency classification and seam discipline of the applied codebase-design skill.

## One mathematical chain, including the machine and serializer

The following are proposed obligations. None is discharged by this document.

| Obligation | Statement and implementation consequence |
|---|---|
| Admission/ingress | Strict bytes → full typed admitted module and explicit inputs preserves the applicable lexical, typing, ordering and metadata rules. Complete module inventory is bound, not only the action used in a benchmark. |
| Initial construction | `Establish(m,p,Ω₀)` either returns the specified invalid-genesis/import result, or constructs D₀ and establishes `Valid(Ω₀) ∧ J(m,p,Ω₀,D₀)`. Used IDs and history are established from genesis or a proved exact import, not inferred from the live snapshot. |
| Kernel rules | Each fixed reduction/reuse/collection rule preserves its semantic judgment and J. Coverage includes both positive and negative dependencies. The rule proof must quantify over arbitrary admitted terms/finite states within its stated profile, not just a generated fixture. |
| Execution | From J, a completed `perform` derivation equals F in every observable channel and establishes candidate J'. Refusal/error preserves canonical Ω; speculative derivations do not mutate canonical roots. Simultaneous effects, checked overflow, lazy skips and selected errors are included. |
| Encoding/observation | `Expand(retained_support, observation_expression)` equals the complete specified observation, and actual encoding/hash code implements the typed encoding. Tree root identity is not the SHA-256 of flattened legacy JSON. Hash domains, lengths, integer bounds and full digest width are explicit. |
| Publication | A finalized allowed candidate publishes exactly once at the exact expected parent. The atomic head links authoritative state, views, lifetime inventory, history, ordered commands, evidence and required proof subject. The losing candidate cannot promote its D or prover state. |
| Machine/proof correspondence | Native interpreter execution and the proved universal machine implement the same kernel rules and encoding. Proving a VM binary image is insufficient until that image is related to the specification, including host inputs, memory initialization, traps and resource behavior. |
| Accumulation | The independent proof certifies initial construction and every finalized machine segment, binding complete subject, request/context/output/commands, logical attempt/commit positions and final roots. Mid-evaluation microsteps cannot masquerade as semantic commits. |
| Independent endpoint | The consumer validates installed kernel/profile/parameter identity, expected genesis/anchor, exact endpoint and committed/attempt coordinates, and compares returned public outputs. A valid proof under a wrong subject fails examination. |
| Recovery | Checked continuation restores the same Ω/J before reuse. A certified root plus authenticated lazy fetches can avoid a complete cold scan, but every value used is fetched and checked. Missing data is unavailable, not an empty query. |
| Activation/migration | The machine's explicit segment rule validates old/new module, schema, policy, profile and kernel identities; executes the required transformation; establishes target J; and preserves lifetime history. New keys/circuit identities have a checked activation chain. A shared schema alone grants no authority. |

Let `Z_i` commit to the exact public subject and authoritative/derived roots at a finalized position. The desired theorem is:

```text
InitSound(Z₀) ∧ KernelRefinesF ∧ Native/Machine/EncodingCorrespondence
∧ VerifyPrefix(expected Z₀, expected Zₙ, proof, installed_kernel_and_keys)
∧ proof-system soundness ∧ commitment binding
⇒ an exact Core-valid history from the claimed Z₀ to Zₙ,
   with its bound requests/context/outcomes/ordered commands/observations,
   and J for the operational state used for continuation.
```

Authority premises and retrieval remain explicit premises/findings, rather than consequences of this theorem. The full-history claim includes initialization. An externally trusted checkpoint changes the theorem's starting premise and is reported as such. This is the composition required by the [greenfield contract](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md), applied to one fixed semantic machine rather than a separate public witness checker.

For succinct independent history verification, the concrete proof route to investigate is an accumulated proof of universal machine execution, including its `Reuse` rule, authenticated state/index accesses and observation/history encoding. It is closer to greenfield B1 with semantics-aware reuse than to a small hand-written closed-fragment circuit. Parameter derivation, memory arguments, variable instruction handling, proof compression and closure are implementation choices that require a benchmark. No generic proof backend is exposed as a caller extension point before two real implementations justify it.

A native `Session` witnesses checked state only inside the trusted native process. It is never serialized as independent proof. A fresh examiner checks the proof of the same relation; it does not accept a producer's private type. Conversely, native correctness is not proved merely because a cryptographic proof verifies: the kernel-to-machine and runtime/serializer correspondences still need proofs or explicit, bounded trust assumptions. Core032's [correspondence ledger](../sources/core/specs/032-transition-verification-study/evidence/correspondence.md) demonstrates why these entries cannot be collapsed.

## Initialization, adversarial imports and cold recovery

For a new untrusted seed, perform complete typing/identity/reference/rule/global validation while constructing the persistent state and initial derivations. Fuse compatible passes and avoid duplicate JSON trees, but count every necessary input byte, obligation and proof instruction. There is no claim of millisecond establishment for an arbitrarily large adversarial seed.

A resumed certified head can establish semantic root validity by independently checking its prefix certificate. It then authenticates needed persistent nodes on demand. Report both time to accepted root and time through the first useful operation, with fetched bytes; otherwise lazy loading can hide cold cost. Continuing the machine requires the retained used-ID and index state, not merely a final business-state digest. Full retained-data audit still reads the promised data.

A prover continuation checkpoint contains more than the final public claim. Its internal accumulator/memory state must be validated against that claim by the selected backend's continuation procedure. Verification of a compressed endpoint proof alone does not establish that an arbitrary serialized prover state is safe to resume. If valid continuation state was lost and cannot be reconstructed from retained certified state, recovery re-proves/replays the required suffix or prefix; the time and data costs remain visible. Parameter caches have the same exact-kernel/shape/recipe binding and cold validation requirements.

Imports cannot select verifier code or authorize a new kernel by shipping a manifest. Installed profiles and accepted authority determine permissible versions; package hashes only identify package contents. Bounds apply before allocation/decompression and to graph depth, lengths, duplicate keys and malformed typed encodings. Exhaustion is not a semantic contradiction. A malformed import must not publish partial canonical state.

## Evidence and versioning decision

The intended fast evidence profile is a **new explicitly versioned structured contract**. Each new event commits to its exact parent, request/context, selected result, ordered commands and sufficient shared observation support, rather than incorporating the complete expanded old decision as its normal hash input. The expansion theorem and retained-data contract are part of that profile. This is a logical evidence change, not merely gzip or a JSON DAG transport.

All old artifacts retain old meanings, IDs, canonical hash algorithms and profile-specific verification. An adoption event binds the old exact head to the new profile and its checked operational state. If a guarantee still names old `StateId`, canonical event hashes or old expanded output, the machine must compute/check those algorithms or a proved exact bridge; publishing both an old hash and a new root is insufficient. SHA-256 and MuHash3072 costs inside the proof are charged, not assumed cheap.

Full legacy audit expansion is a requested operation and costs its actual B bytes. If every new transaction is required to produce/hash the full legacy record, that execution pays the old output-sized work; this candidate cannot claim to eliminate it. The candidate's scaling hypothesis therefore requires adoption of the new evidence profile, while preserving exact execution meaning and old-history support. The profile/identity choice is a reviewable design decision, not a production change authorized by this note. [Existing identity and output floor](../sources/core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md).

The retained representation includes all required module/profile versions, accepted initial data, original requests/context, exact outcomes, ordered committed deltas/command occurrences and support sufficient to reconstruct promised observations. Garbage collection is reachability against promised historical exports and continuation, not merely the current live root. Proof validity can survive later loss of support; `examine` reports missing/corrupt data separately and fails a requested complete data audit.

## Complete language, not a favorable fragment

The generic interpreter is the semantic coverage floor. Reuse rules change execution strategy, not admission. Every admitted syntax constructor and historical profile needs a mapped generic reduction rule, including numeric/typed values, derived expressions, partial operators, bindings/aliasing, lazy control, collections/set operations, aggregates, lifecycle/references, commands, reads/invocations, migrations and governed activation. The coverage inventory must be generated from the authoritative schema/AST and supported public request inventory; this list is not itself a proof that coverage is complete.

The staged implementation obligation would be: define F for the complete supported language; implement generic native and proved execution for it; then add fixed reuse rules with arbitrary-input correspondence theorems. A benchmark may start small to falsify a rule, but the architecture is not complete until every admitted constructor has a path through the same attested machine. A native fallback to current Core is useful during development and for differential comparison, but an attested request using an unproved fallback must report `Unsupported` for attestation. It cannot claim complete end-to-end coverage until the generic proof path exists.

A full generic path may be expensive for arbitrary global predicates or capture changes. That is a performance limitation to expose and improve, not permission to label difficult programs unsupported forever. In contrast with a compiler candidate, this design does not promise derived change code for every term: it promises faithful fixed-machine execution, plus exactly justified reusable derivations wherever the rules apply.

## Cost contract and discriminators

Define `A` as invalidated/affected semantic work, `P` authenticated changed/read paths, `U` new distinct support bytes, `K` proof-machine steps, `C` encoded work per step, `B` explicitly requested expanded bytes, and `H` committed history. These variables can depend on N, captured context, expression complexity and input size. In particular, `A` is not the number of written cells.

| Scenario | Complete charged work | Desired improvement; no measured bound yet |
|---|---|---|
| First establishment | fetch/decode/admit all input; initial F/J construction; trees/indexes; parameters; proof production/closure/check; initial durable publication | Fewer repeated passes and trees; no repeated prefix and no free large seed. |
| Cold certified resume | fetch/check claim/key/certificate; validate continuation state; authenticate necessary nodes; first operation; recovery publication if any | Avoid full reconstruction when the certificate and retained roots really suffice; charge lazy fetches through the useful endpoint. |
| Warm local operation | request/context validation; reverse-dependency/coverage maintenance; affected execution; new paths/support; exact output construction; native checks | Work may follow A+P+U instead of visiting every unchanged row; prove and measure the index laws. |
| Attested operation | all local work plus witness extraction, K×C work, folding/closing/compression, independent check and exact-parent durable publication | No full Core replay bridge; completion includes the requested attestation. Cryptography may dominate. |
| Fresh independent prefix check | expected subject/authority/key validation; data transfer; proof verification; authenticated requested projection | Avoid H-dependent replay only after the complete relation/identity bridge exists. Cold parameters and output remain charged. |
| Full audit/export | relevant support retrieval/integrity; exact reconstruction/renderer; requested semantic/data checks; B-byte emission | Shared storage may reduce duplicate bytes; expanded output remains proportional to B. |
| Lost views/prover state | certified-state restoration or complete required rebuild/re-proving; parameter reload; first useful operation | No assumption that recovery is constant-time or that a valid endpoint proves resumability. |

The lifecycle total sums actual first deployment, cold starts, operations, examinations, exports and recovery for a declared workload. Within-sample contiguous totals, peak/resident memory, distinct retained bytes, transfer bytes, first export, CPU and proof steps are retained. Phase medians are not summed. An asynchronous comparator must report the exact independently accepted head, lag and drained totals; it is not the main `Attested` contract.

Core032's C1/H2 first-use workflow measured 68.818 s, with a separate reuse workflow 22.487 s; compression was absent and a full Core bridge remained. Those numbers motivate proof-lifecycle measurement but neither estimate this machine nor establish a millisecond ceiling. The cumulative compatible optimization measured the right existing records and still needed 4 MB for the large single creation. A claim that this proposal reaches milliseconds requires new absolute measurements. [032 actual proof lifecycle](../sources/core/specs/032-transition-verification-study/investigation.md), [final compatible report](../../core-final-investigation-20261031/report.md).

### Adversarial semantic discriminators

Before favorable timing, falsify the proposed rules with:

- Omit or add a query member, including insertion into an empty result; omit an applicable rule or reverse dependency; forge a complete-looking initial count/index.
- Retarget a reference while removing its former target in one simultaneous transition; remove a referenced target; create an identity removed long ago; supply equal live state at a different history.
- Preserve positivity/cardinality while changing the requested assignment's value; reorder checked additions so an intermediate overflow disappears; evaluate a skipped partial branch; alter the first selected failing subject/rule.
- Change a captured threshold or applicable policy, including broad fanout; change admitted metadata while keeping a narrower behavior hash; present correct proof bytes for a wrong genesis, profile, endpoint or kernel.
- Omit/reorder duplicate command occurrences, omit command-only events, certify an unchecked suffix, or present a denied attempt as an allowed published event.
- Crash before/after object durability and exact-parent CAS; lose acknowledgement of a real command-only commit; race competing candidates; corrupt views/prover continuation; remove audit support after a valid proof.
- Import duplicate/escaped duplicate keys, historical array-form traces and compound errors with frozen precedence; oversized compressed/deep support graphs; missing mandatory objects; a producer-selected verifier executable/key.

Each counterexample targets an actual rule/premise or external finding. A preserved count is insufficient evidence of exact execution; an invalid witness is not a business refusal. Broad captures and adversarial input sizes also belong in performance cases, so a correct expensive path cannot disappear from the reported coverage.

### What would reject this candidate

Reject or revise it if the dependency/coverage invariant cannot be maintained without routine full scans; if a hot `perform` still visits every unchanged derivation; if the full-language proof machine has an unproved native fallback; if full Core identity requires a linear external replay bridge; if `Attested` latency or total lifecycle work misses frozen targets; if proof setup/recovery dominates realistic reuse; or if retained support cannot reproduce the promised historical errors/order/commands. These are architecture failures even when the three entrypoints look simple.

Compare N=128/512/2048/8192, H at independently increasing levels, changed population, removals, simultaneous effects, number/complexity of rules, payload size, broad context changes and equal-state command histories. Include memory and durable adapters, fresh and resident verifiers, first establishment, cold resume, complete attested operation, fresh independent check and full export. Freeze per-scenario latency targets and complete lifecycle workload before implementation measurement. Millisecond ambition is a target, not the present result.

## Advantages, costs and unresolved choice

The main Leverage is one semantic session owning the whole local correctness/publication/proof chain. Locality concentrates exact semantics, dependency laws, error order and evidence interpretation in one fixed kernel. Independent examination crosses the same semantic interface while receiving no private producer authority. The deletion test is favorable: deleting this module forces admission, reuse, history/proof binding and recovery coordination back into every caller.

The main technical advantage over separate optimizer and semantic checker designs is the possibility of proving one execution/reuse calculus and using it in both native and attested execution. Full generic interpretation offers a clear coverage floor. Internal derivation structure supports exact lazy audit expansion without pretending a storage root proves semantics.

The cost is a more substantial trusted/proved kernel than a tiny result checker, plus a proof machine that must support complete language behavior. Dynamic dependency tracking may cost more than static specialization. Broad queries can invalidate large regions. Persistent derivations and their reverse indexes consume memory/retention. Universal instruction and memory proving can cost far more than a specialized circuit. A fixed interpreter may become a maintenance bottleneck, and a superficially small external interface can hide a large specification unless the types/error/performance contracts above remain explicit.

The unresolved selection questions are whether fixed dynamic reuse sufficiently reduces A across real Core programs; whether exact observation projection and coverage can be proved with maintainable rules; whether a single machine actually reduces correspondence work in the deployed toolchain; and whether any concrete proof backend makes **the complete three-stage contract** fast enough. This proposal remains an independent candidate for comparison, not an endorsement of the previously suggested hybrid.

## Primary precedents, with pinned scope

No new external fact required browsing for this proposal. The following precedents and pins were already inspected in the [reassessment's primary-source record](../../core-redesign-reassessment-20261101/researched-alternatives.md); they are references for obligations and alternatives, not imported Core proofs or new benchmark claims:

- [Authentikit pinned security development](https://github.com/jtassarotti/veri-auth/blob/24c41ec37e5f12f75a40b00c65b787dea63810b0/theories/examples/authentikit_buf_magic_state_security.v) supplies a model for authenticated typed-value reuse. Its [basic verifier](https://github.com/jtassarotti/veri-auth/blob/24c41ec37e5f12f75a40b00c65b787dea63810b0/src/basic/verifier_buf_magic_state.ml) clears the cache at `run`; persistent semantic derivations and Core J require additional proofs.
- [DBSP pinned transformation theorem](https://github.com/tchajed/database-stream-processing-theory/blob/fb6ff4416108710448ccd87473c5513c1a1179ea/src/circuits.lean#L348), [ILC pinned theorem inventory](https://github.com/inc-lc/ilc-agda/blob/39bb081c6f192bdb87bd58b4a89291686d2d7d03/PLDI14-List-of-Theorems.agda#L77), and [CTS pinned theorem overview](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/Overview.v#L95) support the distinct compiler/change-program alternative. They do not prove this dynamic machine, Core's ordered checked folds or recovery.
- [Authenticated range indexes](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf) establish coverage through a specified range protocol; individual membership paths are weaker. [Pantry](https://www.pepper-project.org/pantry-sosp13.pdf) places authenticated state access inside verified computation and requires bootstrapping the initial digest. Neither supplies Core initialization/J automatically.
- [Pinned Nova implementation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/nova/mod.rs) separates setup, recursive proof extension/verification and compressed proof operations. It is a possible accumulation implementation, not the defining architecture or a claim that its existing Core032 timings transfer.

The Core-specific theorem, machine implementation, serializer correspondence, continuation protocol and end-to-end measurements remain work to do. This file changes only the architecture record.
