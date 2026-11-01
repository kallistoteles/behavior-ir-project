# The persistence contract

> **The engine defines the canonical state-transition and persistence contract; hosts choose how
> that contract is stored.**

The engine defines what must be preserved for behavior to be reproducible. It never opens files or
connections, and it does not dictate how anything is stored. Details: `specs/005-persistence-contract/`
(spec, research R1–R12, data model, `contracts/store-api.md`, implementation review).

## Guiding invariant

> Every committed transition is reproducible from an immutable semantic state, an exact history
> position, an exact behavior version, exact input and exact context. No storage implementation
> may alter those semantics.

Three concepts are kept apart:

| Concept | Question | Represented by |
|---|---|---|
| State identity | What information exists? | A content hash (MuHash3072) over entity content = type + declaration + id + value. Revisions and positions are **not** content |
| History position | Where in this store's history? | A monotonic position plus the hash chain of transition records from the genesis |
| Entity version | Which historical incarnation supplied a value? | Revision plus the position that created it |

Equal content gives an equal state identity, even at different positions: position 42 and position
57 may both be state `ABC`.

## Pipeline

```text
Store (engine semantics) over a Backend (host storage)
        │  read the head once (state S at position n), every bound entity *as of n*
        ▼
S + input + context + facts as of n ──► evaluator ──► decision + ΔS + observed reads and facts
        │  only ALLOW produces a commit bundle, bound to store and state:
        │  data_version = store:<genesis>;state:<S>;position:<n>
        ▼
commit(expected_parent = S, bundle)
   1. idempotency: a transition evaluated at n can only be record n+1
   2. whole-state concurrency: the exact evaluated state/history must still be the head,
      otherwise STATE_CONFLICT
   3. validation: the record reproduces under its current validation profile;
      complete resulting-state validity is established; read and write sets are re-derived;
      revisions, old values, declarations and facts match; creations use unused identities,
      removals exist, and no reference to a removed entity survives (feature 006)
   4. evidence policy (cited by every record)
   5. the backend's atomic compare-and-set: versions, removals, index changes, record and head
      as one unit
        ▼
new state identity + transition record (evaluated_against == committed_on) + new head
```

## What a host implements

A `Backend` has twelve methods: `genesis`, `head`, `create(genesis, head, seed, seed_refs)`,
`version_at(key, position)`, `version(key, revision)`, `record(position)`, `removed_at(key)`,
`incoming_at(target, position)`, `used_at(key, position)` (with a default), `keys_at(entity_type,
position)` and `keys_by_field_at(entity_type, field, value, position)` (optional, feature 007),
and `commit(expected_last_record, versions, removals, ref_changes, record, new_head)`. Only
`create` and `commit` write.
- **The compare-and-set:** `commit` serializes ordinary transitions atomically and
  crash-safely. Initial creation independently serializes its check/publication on the same target.
- **As-of reads:** stored versions never change and are tagged with the position that created them,
  so reads at one position form a consistent snapshot, even while commits land.
- **Everything else is the engine's:** hosts never re-implement validation, hashing, conflicts or
  replay.

`InMemoryBackend` is the reference backend for logical publication and atomic
updates. It does not claim physical crash durability. The supported
`behavior-engine::store::conformance::run(factory)` uses fresh targets and checks
ordinary persistence together with the initial creation law. Private probes inject
faults/interleavings without Backend hooks; designated broken adapters must fail,
while reordered and optional-unindexed semantic controls agree. Shared outcomes
require additional implementation-specific durable creation interruption evidence.

## Initial Store publication and recovery (feature 019)

Store initialization has one public publication point: **Absent → Complete**.
The complete product is the original canonical Genesis, normalized original
entity versions, derived initial reference relation and initial head. Its existing
Genesis/StoreId identity binds creation; a path, current StateId or current schema
alone does not establish the same creation. Core validates the original candidate
with the full seed validator before requesting any Backend mutation.

A backend may privately stage data in several physical operations. Incomplete or
orphaned staging is never openable, evaluable or replayable as a Store. Actual
public storage is absent or complete; an operational error or lost acknowledgment
can leave the caller uncertain which occurred. That uncertainty is knowledge,
not a third public storage state. Success requires complete publication and the
host's declared durability barrier; verified durable recovery establishes an
equivalent barrier.

A retry of the same original Module/Genesis verifies original versions, universe,
lifetimes, content identities, reference relation and history anchor, independently
of the captured current head. It recovers an equivalent published Store without
a second initialization or any reset of later updates, creates, removals, commands
or migrations. A positively established complete foreign creation yields
`STORE_CREATION_CONFLICT`. Missing positive structural material yields
`STORE_INCOMPLETE` or the existing delegated integrity error. Failed reads remain
operational errors. A failed create receives one bounded classification; only
established complete foreign publication may replace its original backend error.
It neither loops nor converts that failed attempt into successful recovery.

Generic `Store::open` checks structural original publication and bounded captured
history/schema endpoints, and starts cold. With no Module it cannot independently
establish legacy typed normalization, complete Ref semantics or Behavior validity.
Module-bearing original-request recovery performs the stronger exact-product
check. Only verified exact position-zero publication can promote the existing
private Module/profile-bound seed certificate. Advanced or migrated recovery
remains cold, including a later position with the same StateId. Neither form of
opening is full-prefix replay: complete immutable fixed-position Backend history
and enumeration remain explicit contract premises.

This is one mandatory current Backend semantics, not a negotiated capability.
Signatures, historical Genesis/record profiles, Wire/schema/hash domains, replay
meaning and verifier outcomes are unchanged. See the
[creation contract](../specs/019-store-creation-contract/contracts/store-creation.md),
[compatibility assessment](../specs/019-store-creation-contract/evidence/compatibility-assessment.md)
and [external backend migration guide](backend-creation-migration.md).

## Replay

- **Data replay:** re-applies each write set, recomputes every entity version and state identity,
  and checks the record chain, the parents, and `evaluated_against == committed_on`.
- **Behavior replay:** re-evaluates every transition under its recorded behavior version, and checks
  the decision, the changes, the observed reads and the observed facts.
- **Reference replay** (`replay_index(store, module, …)`, feature 006): rebuilds the reverse-reference
  index from entity content and checks it against the backend's `incoming_at`, and each record's
  `ref_changes` against the content changes. It needs the module, because `Ref` fields are part of
  the entity declarations.

All three report the first divergence: its position and kind (`state`, `parent`, `chain`, `record`,
`changes`, `decision`, `invariant`, and since 006 `lifecycle` and `references`). Snapshots are a
cache: `verify_snapshot` confirms them, and they never override the history.

### Current decisions and historical recovery (feature 017)

Fresh ordinary actions use decision record 0.8 and
`behavior.complete_resulting_state.v1`, across all admitted Wire IR versions.
The complete parent must be valid under the exact schema and admitted behavior.
Applying the candidate delta must establish every resulting-state obligation,
including rules on unchanged rows affected by creations, removals, references or
transitive derived dependencies. Postconditions run first; resulting entities
then use canonical semantic identity order, invariants before constraints and
semantic declaration order. The first false or erroring obligation selects the
result and typed witness. Applicable global and lifecycle checks retain their
stages. The [decision contract](../specs/017-resulting-state-validity/contracts/decision.md)
defines the exact schedule and evidence.

Parent snapshot evidence and speculative child observations are distinct.
Decision 0.8 records the complete canonical parent universe; typed parent field
observations also survive conversion to bundle `read_facts`, including reads of
entities without action bindings. Child trace observations use `S'` and cannot
be substituted for parent values. Re-derivation checks the exact parent/schema/
history, required facts, changes and commands before atomic commit. Whole-state
CAS includes history identity, so equal StateId at a different position is not
an interchangeable parent. There is no disjoint-write rebase rule.

Archived decisions 0.4–0.7 reproduce their original validation profile, including
an old recorded ALLOW whose child violates a rule missed by that profile. Data,
behavior and invocation replay use the recorded position and historical schema;
they perform no writes or external command dispatch. An old uncommitted bundle
cannot become a new current commit. Exact recovery of an already committed old
event may return `already: true` and the original occurrence identities, with no
new history, commands or current validation certificate. An old invalid child
still fails fresh current-parent validation; successful historical replay or
recovery does not repair or certify it.

Authenticated historical governance evidence is checked against its original
manifest for historical replay and recovery. That archive check does not make an
old verifier proof eligible for a fresh current subject. Current verification is
0.9.0; policies and Store adoption remain explicit, with no automatic upgrade of
existing stores or historical authorizations. See [versioning](versioning.md) and
[governance](governance.md).

## Universe transitions (feature 006)

> Identity is permanent; existence is state.

The entity universe is part of state. Actions create entities (`create(T, id, {complete value})`)
and remove them (`remove(p)`) as ordinary effects, evaluated and committed atomically with field
updates. Details: `specs/006-entity-lifecycle/`.

- **Identities are host-supplied inputs;** the engine never generates them.
- **The identity registry:** an identity is *used* once any version of it exists, keyed by the
  entity type's name and the id (never the declaration hash). A removed identity is never created
  again: `ENTITY_ID_ALREADY_USED`.
- **Removal is logical:** `removed_at(key)` is set once, inside the commit; versions are kept, so
  `load` at earlier states and both replays still see the removed entity. A removal removes the
  last content hash from the state accumulator; a creation inserts the new one (revision 1).
- **Referential integrity is explicit:** `Ref<T>` is `Id<T>` plus the constraint `exists(field)`.
  Plain `Id<T>` fields never block anything. Integrity is checked on the resulting state S', so
  retarget-and-remove in one transition is valid. A surviving reference is refused:
  under the current profile, its canonical synthesized constraint can yield
  `CONSTRAINT_VIOLATED` before the later removal guard would yield
  `DANGLING_REFERENCE`. Historical records retain their original failure choice.
- **The derived reverse-reference index** answers `incoming_at(target, position)`. It is stored as
  edge events (`added_at`, a set-once `dropped_at`), written in the same atomic commit, never part
  of the state identity, and always reconstructible from entity content (conformance case
  `reference_index_consistency`, `replay_index`).

**The evaluation snapshot.** Evaluation observes *facts*: existence and incoming references
(current state) and whether an identity was used (history). Two positions with the same state
identity can differ in history facts, so the deterministic input is the state *plus* the observed
facts, named by `data_version` (store, state, position). The store answers facts as of the
evaluated position. Reached facts are recorded in the decision record's `facts`
section and the bundle's `read_facts`; current records additionally archive the
complete canonical parent snapshot for replay. The commit re-derives required
facts at the parent and refuses a bundle whose facts differ. Plain evaluation
takes facts from the request (`UNKNOWN_FACT` if one is
missing, `INCONSISTENT_FACTS` if they cannot describe one valid state); replay uses the recorded
facts.

**Trust boundary.** A recorded existence or reference fact is *what the store answered* at that
position, checked again at commit and by replay against the same store. It is **not** a standalone
cryptographic proof: MuHash commits to the state's content, but a fact about absence or about
incoming references cannot be verified without the store (no membership or non-membership proofs).
A reader who does not trust the store must replay against it.

## Relational queries (feature 007)

> Sets are semantic; indexes are implementation.

A query (`select(T)`, `where`, set algebra, and `count`/`any`/`all`/`sum`/`min`/`max`/`unique`
over it) is a pure read of the evaluated state. Details: `specs/007-relational-queries/`.

- **Query facts:** a query *instance* is its definition hash plus its canonical captured values
  (`QueryInstanceId`); a query fact records the instance's complete membership, and member values
  are ordinary field facts. Only what evaluation actually read is recorded, in the record's
  `facts.queries` / `facts.fields` (record version 0.6) and the bundle's `read_facts`, where each
  query also carries a `result_hash`. Records list full memberships even for `count`, so large
  results make large records; this is accepted for now. Overlapping fact representations must
  agree: if a request supplies a complete `universe` and also supplies redundant query or field
  facts for the same state, the engine derives from the universe and rejects contradictions as
  `INCONSISTENT_FACTS`.
- **The evaluation snapshot:** the store answers memberships and member values as of the
  evaluated position, like every other read. `keys_at(type, position)` is the derived type index;
  `keys_by_field_at` an optional field index. The store follows an index plan from the query's
  equalities (a captured value preferred over a literal), then re-checks every candidate, so an
  index can only save work: it never defines a result and is never part of the state identity.
  Conformance: `query_snapshot`, `query_index_consistency`, `query_order_independence`,
  `module_invariant_preserved`.
- **Resulting state:** `Q(captures_S', S') = Q(captures_S', S) + exact effects of ΔS`. Filters are
  candidate-local, so only created, removed and changed bound candidates are re-classified; the
  baseline is an observed fact against S. Nothing speculative is ever written.
- **Module invariants** hold at genesis (`GENESIS_INVALID`) and on every resulting state they can
  be affected by (`INVARIANT_VIOLATED`); a sound dependency analysis skips only unaffected ones,
  and `unique` is decided by a delta rule (only touched members can collide).
- **Replay** never queries a store: plain replay uses the recorded facts; behavior replay
  re-derives them at each parent and compares, result hashes included.

**Trust boundary.** As with existence facts, a recorded membership is what the store answered;
it is not a standalone (non-)membership proof.

## Schema identity and migrations (feature 009)

> State is meaningful only under an exact schema; schema changes never reinterpret history.

- **Store schema:** the entity declarations (fields, field types with the enums and nominals they
  use, references). Its identity is the **SchemaHash** (`behavior.store_schema.v1` over the
  sorted entity name → declaration hash pairs), separate from the behavior version. Behavior-only
  changes leave it unchanged.
- **Exact binding:** evaluation and commit require the module's SchemaHash to equal the store's
  schema at the evaluated position, over every entity type. A mismatch is `SCHEMA_MISMATCH`
  (with every differing type and both declarations) before anything runs. This replaced 0.8's
  touched-types comparison.
- **Schema history:** `Head.schema` names the schema in force since the last migration (it is
  absent while the store is under its genesis schema, so heads of stores that never migrate keep
  their bytes). A migration record carries the previous schema, so `schema_at(position)` and
  `schema_history()` walk back through migration records only. An entity version is
  content-hashed under the declaration in force at the position that created it.
- **Migration transition:** `store.migrate(migration, source, target, …)` reads the complete
  state at the head and applies the migration to it. That means validating the source state under
  the source rules, checking the requirements, transforming every entity of every changed type
  and validating the target state. It commits the new versions (`revision + 1`, created at the
  new position), the reference-index changes, a **migration record** (`kind: "migration"`, a
  `MigrationBundle` instead of a commit bundle; action records keep their bytes) and a head naming
  the new schema, with one compare-and-set. A refusal leaves the store unchanged. The identity
  registry continues across it.
- **Evidence:** the evidence policy's optional `migration` section sets what a migration needs.
  Without it, a migration needs what an action needs. A migration authorization
  (`governance::authorize_migration`) binds the migration hash and the store state. Runtime
  validation is never waivable.
- **Replay:** data replay walks the schema chain itself (never trusting the head). It checks each
  migration record's previous and target schema, which entities changed, their content hashes
  under the target declarations, and the state identity. Behavior replay re-runs each migration on
  the parent state (`replay_behavior_with`, given the migrations by hash). Conformance:
  `migration_atomicity`, `schema_history_consistency`.

Details: `specs/009-schema-evolution/`.

## Reads (feature 010)

The Store retains one successful whole-snapshot validation, keyed by the exact
store/history position, event, state, schema, canonical admitted module and
validation profile. Warm operations can reuse it; they still check bindings,
inputs, authorization and
historical identity-lifetime facts. `open` starts cold and `backend_mut` discards
the entry. Updates and creations can carry validation forward for conservatively
classified local rules and feature 029's selected literal/cardinality globals,
after checking changed/created entities, historical identity freshness and resulting
references, then successful atomic persistence. The selected affected global form is
`count(select(T)) <= K` for an integer literal K. Derived expressions qualify for
locality only when their complete transitive dependencies are local; their observer
computation is retained where template correspondence is not established. Other
global, query-dependent, cross-entity, unknown and removal cases retain reference
execution. See the [supported route, evidence and measured limits](incremental-validation.md). Candidate validation before commit,
failed CAS, lost acknowledgment and read-only event recovery do not grant new
child validation authority. See the
[014 correctness argument](../specs/014-snapshot-validation-reuse/correctness.md)
and [015 reuse contract](../specs/015-incremental-validation-semantics/spec.md).
Cold validation and real queries still scale with their universe; current record
profiles that archive a complete replay snapshot retain complete evidence
materialization and serialization cost, even when a validity proof is reused.
Cache reuse does not authenticate a backend or promise constant time for every
request.

A read observes one exact state and changes nothing. `Store::read(&self, …)` takes a shared
reference, and every write of the backend needs `&mut`, so a read cannot write. It reads the head
once, or the `StateRef` it is given, which must be a state of this store; the module's schema must
equal the schema at that position (`SCHEMA_MISMATCH` otherwise). Bound entities are loaded at the
position; an identity that does not exist there gives a record with `INVALID_BINDING`, not an
error. Facts come from the backend as of the position, as for transitions.

- **Read records are evidence, never history.** The store never keeps them, and a store with any
  number of reads has the same head, records and state identities as without them. A host keeps
  the records it needs.
- **Replay.** `Store::replay_read` checks a record against the store: its `data_version` must
  name an exact state/history position of this store. The read is reproduced under its
  recorded read-v1 or read-v2 profile, using the actual historical schema, bindings and facts,
  and compared with its complete recorded evidence and identity. An inner read in an
  invocation uses the same recorded profile. Standalone `replay_read` checks recorded facts
  without establishing these additional Store obligations.
- **Read intents.** `Store::read_intent` is the capability boundary for untrusted callers: it
  names a declared read, its targets must exist at the position (`UNKNOWN_TARGET`), and every
  problem is listed before anything is evaluated.
- **One version read per member.** A projection fetches each member's version once
  (`EvaluationFacts::entity`) and records only the fields it uses.

Feature [018](../specs/018-strict-profile-replay/spec.md) shares checked read replay
preparation between Core and Store. Raw evidence is decoded strictly before duplicate
keys can disappear into a map, including nested invocation evidence. A missing or
unsupported record profile produces a non-match; it never selects fresh emission defaults.
Historical v1 retains its original runtime, provenance and capture limitations, including
supported Wire 0.8 archives. Fresh Wire 0.8 reads continue to emit v2. The
[support matrix](../specs/018-strict-profile-replay/contracts/support-matrix.md)
states the supported combinations and limits.

Replay retains `matches` and an optional string `diff`. Malformed or ambiguous evidence
produces `matches: false` with a deterministic reason; this adds no structured reason
grammar or promise of a precise nested decoder path. A reproduced evaluation error or
binding refusal can match. Failures from backend operations actually performed retain
the existing operational error channel. Replay neither commits nor dispatches commands,
and neither ordinary action replay nor decode-evidence replay constructs a fresh commit
bundle. Required Store integrity and binding obligations remain mandatory.

Feature [022](../specs/022-replay-evidence-authority/spec.md) corrects that
previously recorded reconstruction limitation. Core interprets the original
request, origin and recorded profile and compares the complete replay evidence.
Store supplies independently anchored historical values and facts. A verified
read transport refusal uses its original `refused_request` text rather than the
empty-object echo. Invocation refusal replay retains intent, host invocation or
documents origin instead of converting the attempt to another request kind.

Replay obligations follow the components actually established by the original
computation. An atomically rejected Snapshot is evidence of what was attempted,
not authoritative state. Accepted earlier values and facts must still agree with
canonical history; omitted sparse evidence stays unavailable. Ordinary Store
routes retain full snapshot prevalidation, including resolution refusals marked
DECODE. Independently applicable history, schema and integrity obligations remain
mandatory, and successful refusal replay creates no commit or command authority.
See the [boundary contract](../specs/022-replay-evidence-authority/contracts/replay-boundary.md)
and [compatibility assessment](../specs/022-replay-evidence-authority/compatibility-assessment.md).
The original [018 observation](../specs/018-strict-profile-replay/evidence/us3-store-review.md)
and its archived execution evidence are preserved as historical evidence.

## Evidence

Every store has a content-addressed evidence policy, fixed in its genesis. It requires either no
governance evidence or a commit authorization matching the transition, with an optional allowlist
of execution policies. Every record cites the policy hash and any authorization hash.

**Historical v1 trust boundary.** `require: commit_authorization` is a *structural* guarantee:
- A well-formed authorization, matching this exact transition, store and state, is bound to the
  commit and cited in history.
- It is **not** yet cryptographic proof of who issued it. Commit results report
  `evidence_trust: "structural"`.

This describes legacy history. Store-v2 uses authenticated trusted governance; it never upgrades historical structural evidence. See [governance](governance.md).

## Scope and follow-ups

- **Concurrency:** it is whole-state in 005. Records already carry observed read sets, write sets,
  and `evaluated_against` / `committed_on`, so a later entity-level rule can accept a transition
  evaluated at S42 onto S45 when nothing it observed or wrote changed, without reinterpreting old
  records.
- **Entity universe:** since feature 006, creations and removals are recorded transitions. Bulk
  import, identity reuse and garbage collection of history remain out of scope.
- **Verifiable facts:** proofs of (non-)membership or incoming references (for example an
  authenticated index) would let a reader check recorded facts without the store.
- **Signed authorizations:** implemented in store-v2 with trusted role keys and exact policies. Legacy structural records remain structural.
- **Resolve behavior by content hash:** `store.commit(bundle)` with a behavior resolver
  (`behavior_hash → Module`), instead of the host passing the module. Today the module is a
  parameter, and `commit` checks first that
  `hash(module) == bundle.behavior_version == record.behavior_version`.
- **Splitting out `behavior-evidence`:** the governance documents could move to their own crate if
  the verifier ever gains heavy dependencies. Today it links no solver.
- **Changing a store's evidence policy:** the choice among a new store, a configuration transition
  or a versioned policy is left open. Records cite the exact policy, so history stays unambiguous.
- **Schema evolution (feature 009):** provably lossless evolution without rewriting data (e.g.
  appending an optional field read as absent), relational migrations that read the immutable
  source state are follow-ups. Reference replay across a schema change takes the module of each
  schema (`replay_index_with`).

## Durable commands and atomic event identity

Canonical transition history is the durable outbox. State versions/removals/reference changes, transition record, command intents, history head and idempotency commit as one backend unit. No separately authoritative delivery-status table exists. Command-only events advance the chain with unchanged StateId and revisions. State equality does not imply history equality.

Checked commands_since pins a full history endpoint and validates canonical chain/trust/materialized as-of state before exposing opaque committed occurrences. Empty/migration events advance the cursor; pages never split commits. Index omission/order cannot alter semantic membership. Candidate intents and above-head records are not dispatchable. Full historical validation can cost more than max_records; see [measurements](command-performance.md).

Occurrence identity derives from StoreId, committed record hash, intent hash and canonical per-intent multiplicity index. It never feeds back into commit identity. Copies agree and divergent equal-state forks differ. Original-event recovery after lost acknowledgment or later history returns the same IDs. Delivery retries/checkpoints belong to hosts; exactly-once external execution is not guaranteed.

The test-only durable consumer backend uses one fsynced snapshot, atomic rename, directory sync and OS writer lock. Separate-process tests prove its injected prewrite failure and lost-ack recovery cases. This evidence is scoped to that backend; arbitrary custom backend honesty is an explicit contract assumption. Data replay authenticates historical archives, Behavior replay additionally rederives exact semantics, and neither executes external business I/O.

### Verified incremental validation (feature 015)

[015](../specs/015-incremental-validation-semantics/spec.md) has an
[implementation plan](../specs/015-incremental-validation-semantics/plan.md);
the private implementation and acceptance evidence are tracked in its feature artifacts. Its
correctness criterion is observational equivalence with full validation of the
resulting canonical state. The complete-child reference boundary corrected by
017 applies equally to full and optimized paths; a parent certificate alone
cannot discharge an affected child obligation. It adds no validation fact to that
state, no Backend method and no public delta capability. Full validation remains sufficient for a
conforming engine and supplies the reference result when reuse is unproven.

Any retained result must bind the exact state/history, schema and admitted
semantics. Materialization can be discarded and rebuilt from canonical inputs;
only Applied permits reuse for the committed child. Historical identity freshness,
request validation, rederivation, integrity refusal, CAS and replay remain
independent obligations. The [private test/proof delta model](../specs/015-incremental-validation-semantics/contracts/delta.md)
is implementation/proof material, not a persistence or language contract. Query,
global and archived-universe work may still scale with the complete state.

Equivalence compares semantic results and required semantic evidence for the same
canonical inputs, rather than backend call traces or hypothetical I/O errors from
omitted reads. Every actually performed operation preserves its existing backend
error behavior. An operation may be omitted only when equivalent evidence already
establishes its obligation; mandatory snapshot, identity, reference, integrity,
trust, concurrency and atomicity checks are not waived. No additional scans are
required merely to detect arbitrary defects outside the valid Backend contract.
