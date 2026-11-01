# Final candidate correctness review

2026-11-01. Read-only inspection of `/tmp/behavior-ir-core-final-20261031`
against base `1a3ae37623cf90b4608a678ef283ee313306d9bb`, concentrating on Core
streaming/views, fixed Store document views, typed-record reuse and the archive
move. Inspected the new controls; did not execute them, build, benchmark or
modify runtime source. Workspace gate results must come from the owning run.

**No concrete semantic defect was identified in the inspected implementation.**
The following are correspondence findings and explicit limitations, not a
claim of exhaustive proof or a replacement for the final gates.

## Canonical hashing

`tagged_hash` delegates to one checked view pipeline. Its float precheck
examines the complete input before `RootProjection` excludes metadata. When
a float exists, the detailed walk uses the former object-key/array-index order
and path construction. Root `hash` floats therefore still fail, and the first
reported float remains a property of the whole supplied document. Projection
omits only the root object's exact `hash` entry; nested borrowed/owned JSON
delegates to Value serialization, and nested composed objects serialize
normally. Correct filtered lengths include an empty hash-only object.
[Core implementation](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/canonical/view.rs),
[former/current boundary](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/canonical.rs:134).

The digest prefix, NUL separator and hexadecimal result assembly remain shared
with the previous text helper. The buffered sink is flushed explicitly before
finalizing; its underlying writer updates SHA and cannot produce ordinary I/O
failure. Existing `canonical<T>` still materializes through `to_value`, and
`to_canonical_string` retains ordinary full serialization including root hash.
This is a complete-buffer resource change, not removal of canonical checking.
[Core hashing](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/canonical/view.rs:103),
[existing APIs](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/canonical.rs:103).

The Core controls compare against the former hash control flow and cover root
metadata floats, multiple float paths, nested hashes, scalar/array/object
roots, integer limits, escaping/Unicode, tag NULs, composed/owned views and
large leaves. The text-materialization counter asserts that a particular
canonical-string helper is bypassed; it is not an allocation census.
[Core controls](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/canonical/hash_stream_tests.rs).

## Store views and conversion/error semantics

The view constructors match the present CommitBundle and TransitionRecord
derive declaration order and all serialization omissions. In particular:
null `read_facts` and empty lifecycle/created/removed/ref_changes are omitted;
None optional fields are omitted; `authorization` is always present even when
null; Some(null) authorization context remains present. The constructors borrow
only existing JSON leaves selected by the documented design update. Every
other field still passes through its existing `to_value` conversion before
canonical validation, in declaration order. Sorted object composition then
restores whole-document canonical order, including float error precedence.
[View constructors](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents/views.rs),
[bundle definition](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:678),
[event definition](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:902),
[scope clarification](design-update-01.md).

Generic public `hash_of<T>` retains its initial arbitrary-Serialize-to-Value
conversion. Thus duplicate emitted map keys, out-of-range integers, nonfinite
float normalization and custom serializer failure selection keep their old
conversion semantics. The private `hash_json` bypass is used only for candidate
content already owned as Value. That content is still built, validated and
passed through the existing governance candidate constructor.
[Generic helper and candidate construction](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:225).

CommitBundle hash format/evidence/history checks still precede view assembly.
TransitionRecord still calls `check_kind` before hashing. Legacy action kind
checking does not newly invoke the contained bundle's semantic hash: its
nested bundle view only reproduces serialization. V2 kind checking retains
its existing bundle hash/history checks. Migration records retain the generic
whole-record path. This preserves the distinction between serialization of
legacy nested content and independent v2 semantic validation.
[Bundle checks](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:757),
[event dispatch/checks](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:932).

The Store controls compare bytes and exact Result values with frozen old
method bodies, mutate the current schema's fields, exercise omissions,
Some(null), compound float order and legacy nested-bundle validation, and
retain generic serializer edge controls. Their frozen Store method bodies
still call current generic/Core hashing; independence is layered through the
separate frozen Core hash controls, rather than a wholly independent second
runtime. Source-site counters demonstrate bypass of chosen materializations,
not absence of every deep copy or allocation.
[Store controls](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents/hash_view_tests.rs),
[frozen methods](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents/frozen_hash_reference.rs).

## Typed-record reuse and archive ownership

Replay still strictly decodes its incoming text once before profile selection.
The current-profile branch now validates that immutable decoded Value directly.
It does not remove closed typed/profile validation or the later exact record
comparison. The direct common Record07 construction shares the existing field
validator and preserves current-profile checks before common checks. Trace
objects are eligible only when every raw trace step is an object; array-form
steps retain the old projection/parse path, including accepted short sequence
forms and positional excess-element errors.
[Replay ingress](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/record.rs:429),
[profile selection](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/record.rs:521),
[guard/move/fallback](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/record.rs:1160).

The differential controls retain pre-refactor validators, field mutations,
omissions/unknown fields, nested and trace sequence forms, numeric boundaries
and compound-error ordering. Replay controls separately cover strict lexical
ingress, exact selected errors, Unicode/whitespace and module profile mismatch.
These address the subtle compatibility risk introduced by replacing a second
typed decode with moves; they do not make future type changes automatically safe.
[Typed controls](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/src/record/typed_materialization_tests.rs),
[replay controls](/tmp/behavior-ir-core-final-20261031/crates/behavior-core/tests/replay_materialization.rs).

The archive move hashes the fully populated archive at final assembly, then
moves that owner into the event. No fallible semantic operation is crossed;
the caller's borrowed bundle and the earlier archive clone remain. Backend
validation/copying and publication behavior remain in place. Allocation,
destruction and OOM/panic behavior are intentionally not correspondence claims.
[Final assembly](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2600),
[earlier ownership audit](../core-bundle-ownership-20261031/source-audit.md).

## Limitations to retain in the final recommendation

- **Manual schema synchronization:** no current field mismatch was found, but
  views and mutation tests both enumerate fields manually. A future field that
  defaults to an omitted value could evade representative byte controls if its
  enumeration is not updated. Keep the field/attribute inventory mandatory.
  Exhaustive struct destructuring without `..` would be a useful future compile
  failure when fields are added; this is maintainability hardening, not a
  demonstrated current defect.
- **Implementation API surface:** DocumentView and tagged_hash_view are public
  in behavior-core because Store uses them across the crate boundary. They are
  explicitly implementation facilities and are not re-exported through the
  supported behavior-engine facade. Do not describe the patch as introducing
  no public Rust symbols; the narrower no-new-facade-surface claim is supported.
  [Facade canonical exports](/tmp/behavior-ir-core-final-20261031/crates/behavior-engine/src/lib.rs:65).
- **Pinned representation premise:** canonical object ordering assumes the
  existing dependency features without serde_json preserve_order. Preserve
  the locked feature identity in reproduction artifacts. Neither this patch
  nor this review establishes arbitrary feature-unified dependency behavior.
- **Diagnostic cost:** validation-work retains byte-count serializations and
  changes their sink implementation in the view path. Such runs are diagnostic;
  their elapsed costs cannot substitute for normal-build timing. The semantic
  output and independent validation obligations still apply to every arm.

The inspected implementation follows the protocol's stated trust boundaries.
Adoption still depends on the owning final workspace gates, frozen complete
outputs and same-campaign end-to-end observations; this source review makes
no performance or exact hardware-cause claim.
