# Remaining document/hash work: primary-source audit

2026-10-31. Read-only inspection of `/tmp/behavior-ir-core-bundle-20261031`,
whose HEAD is `1a3ae37623cf90b4608a678ef283ee313306d9bb` and whose working tree
contains the guarded record candidate and archived-bundle move. No runtime
source edits, builds, tests or measurements were performed by this audit.
Recommendations below are experiments, not measured gains. The pinned local
dependency sources are serde_json 1.0.151, serde_derive 1.0.229 and SHA-2 0.10.9.
[Lockfile](/tmp/behavior-ir-core-bundle-20261031/Cargo.lock:790)

## Recommendation

First isolate a **Core Value hashing** arm: retain complete canonical validation,
serialize a borrowed view of the input directly into a bounded buffered SHA-256
writer, and exclude only the root object's `hash` entry. Keep generic
`canonical<T>`, Store `hash_of<T>`, public signatures and independent validation
boundaries unchanged. This is the narrowest supported change: it eliminates the
full canonical text allocation on all `tagged_hash` calls and the document clone
when root metadata exists. It does not eliminate Store's preceding document
materialization. Today Core validates, optionally clones/removes metadata,
serializes to String, and then passes those bytes to SHA.
[Current pipeline](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:133),
[Store materialization](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:226)

The stronger separate arm is a **private borrowed Store document view** for
`CommitBundle::hash` and action `TransitionRecord::hash`: materialize the other
fields using their current `serde_json::to_value` behavior, but borrow the
already materialized `CommitBundle.record` JSON tree. Build a sorted object view
around these fields, then validate and hash that view. This addresses a known
large copy in document-to-Value conversion without replacing public generic
serialization. Retain a migration fallback initially. A streaming-only win is
not a claim that the large document-to-Value cost has been removed.
[Bundle fields](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:674),
[record fields](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:897)

The prior illustrative counter-off N8192 observation assigns 155.621 ms to five
document-to-Value conversions and 84.957 ms to canonical serialization; it also
assigns 111.961 ms to digest/setup/hex scopes. Those are source-site elapsed
groups, not predictions of the benefit of either proposal. The bundle move
study leaves document/canonical materialization as its next target and preserves
the first-serialization uncertainty.
[Residual evidence](../core-residual-profile-20261031/report.md),
[latest ownership result](../core-bundle-ownership-20261031/report.md)

## Core implementation contract

1. Run `check_canonical_value(doc)` on the **complete** original input before
   writing content bytes or filtering a key. Retain its fast `contains_float`
   pass and exact diagnostic traversal. A float under excluded root metadata
   must still produce `CanonicalError::Float("$.hash.items[0]")`; sorting and
   array order determine the first error. Existing canonical tests pin this
   behavior. Do not validate only the projected object.
   [Validator](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:89),
   [complete-input control](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical.rs:6)
2. Use a private `Serialize` wrapper that matches only `Value::Object` at the
   root and calls `SerializeMap::serialize_entry` for every key except exactly
   `hash`, in existing map iteration order. Supply the correct filtered length,
   including zero for a hash-only object. Delegate all nonobject values and all
   child values to the pinned `Value::Serialize` implementation. A recursively
   applied filter would incorrectly drop nested content.
   [Root exclusion contract](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:133),
   [Value serialization](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:11),
   [nested-hash control](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical_tagged_hash.rs:37)
3. Feed `UTF8(tag)`, one zero byte and the compact serializer output to the
   same SHA-256 state and retain exact `sha256:` plus lowercase hex output.
   `serde_json::to_string` already delegates through `to_vec` to `to_writer`,
   so retaining the same Value/wrapper and default compact formatter preserves
   escaping and scalar encoding without writing a second JSON encoder.
   [Digest/output](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:150),
   [pinned serializer](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:2177),
   [String path](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:2213)
4. Buffer serializer writes using a fixed bounded capacity and explicitly flush
   before finalizing the digest. The SHA sink's `Write::write` must consume all
   supplied bytes and return their length; flush must not inject bytes. Handle
   serialization/flush errors using the existing `CanonicalError::Serialize`
   mapping rather than `unwrap` or silent `Drop` flushing. The sink is in-memory
   and should introduce no recoverable I/O failure. Buffer size is an experimental
   choice; source alone does not establish its optimal size or a speedup.
   The compact formatter emits separate small punctuation/string fragments, so
   a direct digest update on every fragment is a materially different execution
   path from the present full-buffer update.
   [Small writes](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:1734),
   [object punctuation](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:1861)
5. Retain `tagged_hash_canonical_text` for callers already holding the exact
   canonical String. It is used by invocation paths that deliberately reuse
   previously produced text; converting those callers back to JSON would undo
   reuse. A shared digest-prefix/final-hex helper is a local factoring option.
   [Existing text reuse](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/invocation.rs:1137)

The current JSON map uses BTreeMap, and both map/Value serialization iterate it.
Neither the inspected dependency manifests nor lock dependency list enables
`preserve_order`/IndexMap. The optimization should retain the repository's
existing feature assumption, and validation should record actual enabled
features; it should not advertise arbitrary `preserve_order` compatibility.
[Core dependency](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/Cargo.toml:10),
[lock dependencies](/tmp/behavior-ir-core-bundle-20261031/Cargo.lock:810),
[Map representation](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/map.rs:23)

## The private Store view: a bounded next step

An adequate private representation is an enum with an ordinary JSON node
(`Cow<'a, Json>` or separate owned/borrowed variants) and an object node
(`BTreeMap<&'static str, Node<'a>>`). Borrow only `bundle.record` initially;
leave other JSON such as `read_facts`, writes, authorization context and evidence
on their existing `to_value` path. This is deliberately a partial optimization:
those fields can also be large, and they remain materialized. The inspected
bundle owns every field, so the temporary view's immutable borrow fits within
each synchronous hash call without introducing persistent caches or ownership
changes.
[Bundle ownership/fields](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:671)

Build a CommitBundle view in original derived-serialization **declaration
order**, inserting each `serde_json::to_value(&field)?` result into the sorted
view and inserting a borrowed record node at the original record position.
Current `Value::Serialize` to Value cannot fail for its represented JSON values;
it visits values/arrays/maps and allocates owned strings/maps. Skipping that
copy does not skip a user-controlled Serialize implementation. Materialize all
other fields before canonical validation, preserving conversion-error-before-
float-error behavior. The view must then validate in canonical **key** order,
which differs from construction order. Serde derive visits source fields in
order, while Value's serializer reduces into an ordered map.
[to_value entry](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/mod.rs:995),
[Value's conversion behavior](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:11),
[derived field order](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_derive-1.0.229/src/ser.rs:1105),
[map reduction](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:417)

For `CommitBundle`, include all mandatory fields, omit `read_facts` only when
null, `write_lifecycle` only when empty, and the three optional evidence/history/
context fields only when None. For `TransitionRecord`, preserve its optional
kind/bundle/migration omission and empty created/removed/ref_changes omission;
`authorization: None` still serializes as `null`, because that field has no skip
attribute. Action record serialization nests the borrowed bundle view.
Materialize the other record fields in declaration order. Initially keep
migration records and unknown formats on their current dispatch paths.
[Bundle attrs](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:674),
[event attrs](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:897)

Exact builder order (each ordinary entry means current `to_value(&field)?`,
before any whole-view canonical checking):

| CommitBundle, in order | Inclusion/materialization |
| --- | --- |
| format, evaluated_state, behavior_version, store | Always, ordinary |
| record | Always, borrowed Json |
| transition_hash, entity_declarations, read_set, write_set | Always, ordinary |
| read_facts | Ordinary only when non-null |
| write_lifecycle | Ordinary only when nonempty |
| commit_time | Always, ordinary |
| evidence, evaluated_history, authorization_context | Ordinary only when Some; serialize the field's Option value or its Some payload consistently (both encode the same JSON here) |

| TransitionRecord, in order | Inclusion/materialization |
| --- | --- |
| format, position, previous_record | Always, ordinary |
| kind | Ordinary only when Some |
| bundle | Composed bundle view only when Some, without adding semantic checks |
| migration | Ordinary only when Some; first arm can retain whole-record fallback for migration |
| bundle_hash, evaluated_against, committed_on, result_state, new_versions, evidence_policy, authorization | Always, ordinary, including null authorization |
| created, removed, ref_changes | Ordinary only when nonempty |

These lists are derived directly from the two struct definitions and their
derive attributes. They are not canonical output order; sorted maps determine
output and float traversal order after materialization completes. The checked
entrypoints still control dispatch/error precedence before either builder runs.
[Bundle source](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:674),
[record source](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:897)

The view needs exact whole-document float validation. Prefixing separately
validated borrowed-record errors is insufficient if another lexically earlier
field contains a float. Walk sorted view objects and arrays with the same path
grammar and first-error ordering as Core (`$.bundle.record.trace[0]...`, with
literal dotted keys as today). On success avoid diagnostic path allocations.
Centralize the checked writer/validation in Core using the small cross-crate
view seam described below. Duplicating those algorithms in Store is a less
maintainable option and is not the recommended final materialization arm. Do not
introduce an “already canonical” escape hatch as a shortcut.
[Current path semantics](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:89)

### Central authority and supported API boundary

Use one Core-owned cross-crate representation, for example
`CanonicalValue<'a> { Owned(Json), Borrowed(&'a Json), Object(BTreeMap<&'a str, Self>) }`,
with a checked `tagged_hash_view(tag, &view)` entrypoint. Store's field assembly
functions remain private. This type/function must be Rust `pub` for Store to use
them across crate boundaries; they need not be re-exported from behavior-engine.
The facade explicitly documents Core, Store and Verify as implementation details
that may be reorganized freely. The public-surface gate checks explicit facade
exports/functions against `api/engine-surface.txt`, rather than scanning every
`pub` item of implementation crates. Thus this seam changes an implementation
crate's callable surface while preserving the supported Rust facade, CLI and
document surface. It is not necessary to frame the boundary as only JSON/CLI.
[Owning facade contract](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-engine/src/lib.rs:1),
[gate scope](/tmp/behavior-ir-core-bundle-20261031/scripts/check-public-surface.sh:19),
[explicit canonical exports](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-engine/src/lib.rs:65),
[versioning authority](/tmp/behavior-ir-core-bundle-20261031/docs/versioning.md:236)

This is preferable to a Store-owned copy of canonical checking and hashing:
Core remains the authority for float acceptance, first-error paths, root-only
metadata exclusion, serde escaping, domain prefix and hex output. Existing
`tagged_hash(tag, doc)` delegates to the shared checked helper using
`Borrowed(doc)`, without converting the complete Value tree into view nodes.
`Owned` and `Borrowed` leaves delegate to the same current Value traversal and
serialization; `Object` composition iterates BTreeMap. An `Array(Vec<Self>)`
variant is unnecessary for the first arm: required composition is event → bundle
→ record, all object edges, and normal Json leaves already represent arrays.
Adding an Array variant is defensible only if an actual call site needs mixed
owned/borrowed array children. The type name must not imply that construction
proves validity: its checked entrypoint always validates the complete view.
[Existing canonical authority](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:89),
[required nesting](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:897)

The shared implementation must handle `hash` at either kind of root object:
a borrowed/owned `Value::Object` and a composed `Object`. Validation walks its
value before exclusion; output filters the root entry once; nested composed
and Json object nodes include every key. Treating all composed objects as roots
would change event hashes. Keep the existing text helper's domain and output
formatting in that same Core module. No caller-supplied unchecked byte chunk or
raw-JSON injection is needed.
[Root-only rule](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:133)

Maintenance obligations remain in the private field assembly: the view mirrors
two serialized structs and their omission attributes. Put builders adjacent to
those structs, keep declaration-order `to_value` calls explicit, and compare
view bytes with the original whole-struct `to_value` reference in tests. Avoid a
custom generic serializer adapter that detects a field called `record`: it
widens the implementation to arbitrary serializers/key protocols and makes the
known-type correspondence harder to review. Trusted evidence should continue
through its current `to_value` field materialization; its Serialize implementation
calls `as_json()` and serializes that retained claim. This arm does not claim to
remove that evidence clone or the separate v2 candidate materializations.
[Field attributes](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:674),
[trusted transport](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-verify/src/governance/trusted.rs:2666),
[claim clone](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-verify/src/governance/trusted.rs:500)

Keep existing semantic/hash dispatch exactly where it is. In particular:

- `CommitBundle::hash` must still reject legacy v2 semantics before hashing;
  v2 must still build/check its governance candidate before rejecting structural
  legacy evidence. Only replace the final materialization/hash leaf.
  [Dispatch/order](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:752)
- `TransitionRecord::hash` must still run `check_kind` before format dispatch.
  Nested bundle **serialization** must not start calling `bundle.hash()`:
  current `to_value(record)` serializes fields without bundle semantic checking.
  V1 `check_kind` checks a bundle format only; v2 explicitly invokes bundle hash.
  Adding checks while serializing would change v1 acceptance and error order.
  [Event checks](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:925)
- The backend independently calls `record.hash()` after its CAS precondition.
  It should benefit from the same implementation while retaining its check;
  do not pass a trusted precomputed hash across this boundary.
  [CAS precondition](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/memory.rs:348),
  [independent hash](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/memory.rs:378)

## Why tempting shortcuts are unsafe

| Shortcut | Concrete mismatch |
| --- | --- |
| Replace public `hash_of<T>` or `canonical<T>` with `to_writer(T)` | Derived struct declaration order is not sorted (StateRef is `state,position`); generic maps may have arbitrary order. Current to_value also collapses duplicate emitted map keys by insertion, whereas direct JSON writing emits them. [StateRef](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:312), [map conversion](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:417) |
| A generic serializer that merely sorts struct fields | Nested maps, duplicate key reduction, custom Serialize failures and integer-domain behavior remain. Pinned to_value rejects i128/u128 outside i64/u64; direct JSON serializer writes those wide integers. [Value range](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:96), [direct range](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:114) |
| Drop root hash before validation | Excluded metadata is still required to be canonical; its precise float path is externally tested. [Test](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical.rs:6) |
| Remove every field named hash | Nested hashes remain content. CommitBundle's record hash keys and other nested identities are bound by the outer hash. [Core contract](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/canonical.rs:133) |
| Reuse Store's bundle hash to skip v2 nested/backend checks | Hash methods validate their inputs and backend verifies a complete argument product at an independent boundary. [check_kind](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:939), [backend](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/memory.rs:365) |
| Cache governance_candidate while changing hashing | Candidate construction materializes and validates its own content, so this is a different v2-specific reuse experiment, with separate error/order obligations. [Candidate](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:707) |

## Red goals and controls before timing

For the Core arm, add a diagnostic source-site resource goal that fails on the
old code because canonical text is materialized and (for a metadata input) the
document is cloned. Afterward assert zero such source-site operations and a
bounded writer capacity on a multi-buffer document. Label these as work-site
counters, not total allocations. An independent test sink should capture exact
writer bytes and compare them with old clone/remove/to_canonical_string output;
hash equality alone is a weaker diagnostic for a changed encoder. Test empty,
hash-only, nonobject root, nested hash, Unicode/control characters/escapes,
i64/u64 extremes, long strings and values spanning buffer boundaries. Retain
the old canonical/hash-vector suites and exact full-input float paths, including
multiple floats whose canonical first error is before/inside/after root hash.
[Existing reference](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical_tagged_hash.rs:8),
[canonical cases](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical.rs:6)

For the Store arm, the red resource goal is specifically that known bundle and
action event hashes no longer materialize the decision-record subtree via
`serde_json::to_value`; backend record hash calls remain. Compare captured view
bytes and complete `Result<String, StoreError>` against the untouched generic
`hash_of(tag, &document)` reference for generated and archived v1/v2 bundles and
events. Include every omission combination, nested hash fields, context,
evidence and compound float errors. Pin semantic-precedence cases: legacy
context plus float; unknown format plus float; invalid v2 candidate plus legacy
evidence/float; invalid event kind plus float. Also test malformed public v1
event values directly, so a view cannot silently add nested bundle checks.
The generic reference remains available because the public helper is unchanged.
[Reference mapping](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:226),
[existing late-hash order controls](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/tests/bundle_hash_order.rs:63)

For the central view seam, add differential controls over logically equal views
with all combinations of owned/borrowed/composed root and nested object nodes.
Include root hash metadata on each root representation, nested composed hash
content, and floats in an earlier owned field versus a later borrowed field and
vice versa. Require exact error variants/paths against a fully materialized
reference; capture bytes before hashing using the same authoritative serializer.
For Store, generate multi-field float poisons in record, read_facts, write old/new,
context and legacy evidence, and preserve the entire returned StoreError string.
Retain golden hashes as well: a shared implementation used by both candidate
and reference can mask a regression, so old immutable vectors and a locally
frozen old-code reference remain valuable independent controls.
[Golden Core reference](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/tests/canonical_tagged_hash.rs:8),
[generic Store leaf](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:226)

Pin the unchanged generic helper explicitly with custom serializers that emit
duplicate map keys, reversed key order, a wide u128 and a custom failure after a
float-valued field. Those controls prevent a later refactor from accidentally
using the direct writer for arbitrary T: to_value's reduction/range/failure
ordering remains normative. Keep diagnostic document_hash_calls and byte counts
semantically comparable for specialized paths, counting view serialization only
under validation-work; never restore complete materialization merely to count
bytes in normal timing binaries. Source-site copy goals and unchanged hash-call
counts measure different properties and should both be retained.
[Generic behavior](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/documents.rs:226),
[diagnostic fields](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-core/src/eval/work.rs:1)

Preserve exact complete decisions, bundles, stored events, record IDs, history,
entity versions, command pages and data/behavior replay; retain authenticated
context insertion/recovery and backend fault/atomicity controls. Time fresh
normal release binaries without diagnostic counters, keep evaluate, commit,
first post-commit serialization and wider process results separate, and retain
all adverse pairs. The previous first-serialization context effect remains an
open question; altered transient allocation/destruction cannot be assigned a
CPU/allocator cause from equal bytes or elapsed scopes.
[Existing preservation protocol](../core-bundle-ownership-20261031/protocol.md),
[context evidence and limits](../core-residual-profile-20261031/report.md)

## Read-only review of the staged implementation

The staged [design clarification](design-update-01.md) extends borrowed leaves
from record to `read_facts` and the Some payload of `authorization_context`, and
uses a private `hash_json` for the already owned v2 candidate content. These
extensions have the same fixed-Value premise: they skip Value-to-Value ownership
copies, without bypassing arbitrary Serialize behavior or canonical checking.
The candidate's owned JSON construction and semantic reconstruction remain.
[Private field builders](document-views.rs:10),
[candidate and hash_json changes](view-documents.rs:225)

Read-only review found no necessary runtime correctness or lifetime fix in the
four staged source files. The builders match declaration order and omission
predicates, including null authorization and Some(null) context; the borrowed
view lives only through the synchronous hash call. Nested Serialize delegates
without projection, so nested hashes remain content. The root projection
handles both Json object leaves and composed Object nodes, complete validation
runs before projection, and the fixed 8192-byte BufWriter flush completes
before digest finalization. `check_kind`, format dispatch and migration fallback
remain at the same semantic boundaries. Generic `hash_of` still performs
to_value before delegating to hash_json; the latter preserves diagnostic counts
and canonical error mapping. This is a source review, not executed verification.
[View authority](stream-view.rs:18),
[root projection and writer](stream-view.rs:54),
[Core delegation](stream-canonical.rs:136),
[Store dispatch](view-documents.rs:758)

Before measurement freeze, strengthen evidence with exact captured composed
bytes (the inspected tests primarily compare hashes), an Owned Json root view,
Some(null) context versus absent context, and a deliberately malformed public
v1 event whose nested bundle has forbidden v2 semantics. That last event must
retain old event.hash behavior: v1 check_kind checks bundle format, whereas
bundle.hash itself rejects legacy context. Add explicit compound semantic/float
precedence cases and a generic Serialize error after a float-valued field, to
prove full conversion errors still precede canonical validation. These are
coverage improvements; this inspection did not discover a runtime defect.
[View root cases](stream-view.rs:70),
[v1 nested check distinction](view-documents.rs:951),
[generic conversion order](view-documents.rs:225)

The initial source-site resource goals detect calls through named old
materialization/string paths. They support that exact resource claim, not an
allocation census; a future hidden materialization elsewhere would need its own
source inspection or counter. Keep the report language tied to source sites.
[Original materialization site](baseline-documents.rs:226),
[new private materialization sites](document-views.rs:5)
