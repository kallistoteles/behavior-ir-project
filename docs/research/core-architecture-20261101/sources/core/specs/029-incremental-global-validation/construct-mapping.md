# Core 029 construct and correspondence map

Status: authoritative-source and implemented G1/G2 correspondence map. The finite-state
argument remains conditional on trusted Rust/Backend implementations. Concrete symbols
are mapped below; evidence/g2.md and the US2/US3 controls record the applicable tests.
This document does not replace semantic, mutation, recovery or performance gates.

## Identity and authority

| Representation | Existing authority | Required connection |
|---|---|---|
| Admitted module | `behavior-core/src/admit`, semantic `Module` | Inspect admitted typed constructs, not source spelling or a producer's inventory. |
| Exact observable module | `serialize::to_wire_json`; Store `SnapshotIdentity.behavior` | Bind locations, display/parameter names and profiles as well as semantic hash. A matching BehaviorHash alone does not justify copying rendered evidence from different source metadata. |
| Complete parent | Store `validate_snapshot_full`, `SeedFacts`, Core `provider_snapshot`/`validate_complete_snapshot` | Full bootstrap establishes coherent typed membership, canonical values, every applicable rule and errors. Reuse must be derived from this exact content. |
| History/schema | Store `snapshot_identity`, `schema_at_position`, full HistoryRef | Include Store, record, position, state, schema and behavior/validation context. Equal StateIds/counts cannot bridge histories. |
| Ordinary transition | `run_transition`, effect application and complete resulting state | Inventory actual assignments/creates/removes, aliases and simultaneous effects. An untrusted bundle is not the transition authority. |
| Publication | Existing Store commit/rederive/CAS and `carry_incremental_child` | Exact Applied child only; uncertainty/conflict cannot promote speculative evidence. |

Paths in this document are relative to `crates/` unless explicitly repository-relative.

## Obligation roots and dependencies

Start from every entity constraint, state invariant and module global invariant under
the exact admitted profile, plus each actual transition's complete effects. Preserve
action coverage irrespective of authoring origin/name. Unused definitions are not roots;
called definitions require full transitive resolution, arity and binding checks.

| Construct | Existing semantic source | Optimization obligation |
|---|---|---|
| Local fields/params/literals | `semantic::expr::ExprKind`, ordinary evaluator | Formal-to-actual binding must refer only to the row under analysis. |
| Checked scalar composition | `Evaluator::value`/predicate and scalar helpers | Equal typed inputs preserve values/errors and lazy activation; no replacement arithmetic or partial-function semantics. |
| Derived calls | Profile-dependent ordinary target resolution; Feature015 dependency closure | Check actual target/hash/name/formals and all branches. Locality alone does not prove observer/memo replay; unsupported correspondence retains reference execution. |
| Synthesized Ref constraints | Declaration `reference_fields`, ordinary `exists` evaluation | Valid parent plus no removal preserves unchanged targets; check changed/new refs against one simultaneous child. Arbitrary exists/referenced is not this special case. |
| Unfiltered typed select/count | `QueryKind::Select`, `Evaluator::query_s`/members, `ExprKind::Count` | Membership is exact typed identity membership. Preserve checked conversion, canonical base member facts and child delta semantics. |
| Literal cardinality bound | Typed `Cmp(Le, Count(Select(T)), Lit(Int(K)))` | Compare exact child count; no missing/extra filters/captures or guessed equivalent form. Other shapes may use reference behavior. |
| Unknown/nonlocal/partial global | Ordinary evaluator | Affected/reference. Never interpret failed analysis as zero dependencies or weaken admission. |
| Removals/migration | Ordinary lifecycle/migration paths | Outside the first incremental theorem. Preserve existing runtime Ref integrity and boundary checks. |

The selected count summary follows exact membership under fresh distinct creates.
All field updates preserve that membership. Multiple types, rule roots and actual
operations are independently accounted for; one shared summary cannot erase obligations.

## Validation phases and errors

`check_behavior_snapshot` decodes canonically keyed rows, preserves identity/decode
diagnostics and accumulates row then global failures. `validate_complete_snapshot`
also establishes complete typed universe/normalization. `check_query_snapshot_inner`
checks universe/request binding consistency; request decoding and alias rejection are
separate phases and cannot disappear with a valid-parent cache.

`run_complete_child_rules` checks every complete child row in canonical order with
invariant/constraint ordering and first-failure/skipped behavior. Skipping a proved
empty snapshot failure contribution does not by itself preserve this action trace.
Malformed changed rows, absent targets, arithmetic errors and lazy branches require
ordinary exact activation/order or reference fallback, not assumed success.

## Observer correspondence checklist

For unbound unchanged subjects, ordinary `run_rules` emits explicit subject/obligation
identity, rendered rule metadata, reads, child observations and numeric/rescale evidence.
`observe_parent_fields` records immutable parent field facts, even if child evaluation
used another value for a changed row. Bound, changed and created subjects must retain
their distinct attribution and parent-existence semantics.

Any replayable row contribution must account for all relevant Evaluator effects:

- Ordered trace, error/skipped shape, source locations/text and typed encodings.
- Parent field/existence/query facts and root read-frame attribution.
- Operand-value and semantic-failure bookkeeping that can affect later diagnostics.
- Derived memo hit/miss behavior, derived entries/order and argument/phase keys.
- Rescale, candidate and fact-error state where applicable.

Caching only `true` or a trace vector is insufficient. If the implementation cannot
establish a construct's complete observer correspondence, keep reference execution
for that optimization domain. This does not make the admitted language Unsupported.

## Reproduction and cache lifecycle

`record::reproduce_observed_with` validates record/profile and reconstructs a request,
then compares the complete independently expected decision. Store `rederive_for` also
checks actual historical bindings and builds read/write evidence. Reusable checked
semantic evidence may remove duplicate work, but neither an untrusted result nor a
cached approval can replace actual-parent/request correspondence and tamper rejection.

Core must own checked construction and private representation of prepared state/evidence.
Store owns history continuity and couples publication to exact CAS. Do not export a
consumer Boolean/JSON constructor that asserts validity. Cold open, explicit Backend
mutation, module/schema/profile change and migrations re-establish ordinary authority.
All optimization data remains ephemeral and unnecessary for deterministic Core replay.

## Measurement mapping

The public example `crates/behavior-store/examples/global_validation_bench.rs` uses
the same neutral fixture/workload definitions as private reference tests. Its default
release build has no diagnostic feature and no unit-test strategy switch. The separate
`validation-work` feature counts source-defined work; diagnostic timings never establish
speedup acceptance. Exact-release timing is built from isolated archived release source
plus only the measurement fixture/driver and a disabled feature declaration.

`snapshot_rows`, `decoded_rows`, `child_rows`, predicate/query/provider counters and
Backend work explain different mechanisms. Selected `copied_rows` and document JSON
byte proxies are not universal allocator/hash-input traces. Complete wall/phase/resource
measurements and output bytes remain necessary. Later strict work controls must establish
that no unrelated row is semantically revalidated, not merely stay below a coarse total.

## Required closure evidence

G1: actual Core/Store interface symbols, exact-module/parent/binding/record controls,
observer correspondence and update/create evaluation/reproduction demonstration.
G2: actual effect/summary mapping and arbitrary-state membership/frame proof.
G3: all adversarial, mutation, context and recovery controls plus normal gates.
G4: frozen unbiased complete-path growth comparison with measured residual costs.
No item in this mapping asserts that those later implementation gates already passed.

## G1/G2 implementation correspondence

`eval::prepared::PreparedSnapshot::new` runs existing provider capture and complete
validation. `validate_bindings` restricts only the already-valid unrelated universe,
retaining actual bound values and ordinary consistency checks. `checked_child` takes
its delta from the actual World after ALLOW; it cannot be built from submitted JSON.
`PreparedChild` updates the exact typed maps and future ordinary row templates after
Store's existing exact-parent/CAS checks. No count-only Store overlay is authoritative.

`run_child_row` is shared by reference execution and template construction. Templates
exclude every unrecognized or memo-bearing expression constructor. Ref constraints
are the existing synthesized rules; no-removal is checked before reuse. Child preflight
errors and canonical merged order match `complete_child`. Count's selected fast path
retains query observations and checked i64 conversion. Derived observer effects, filtered
queries and unsupported globals remain ordinary, even if another local predicate could
be proven independent. See evidence/g2.md for conditional frame reasoning and controls.


Prepared evaluation now carries a private call-scoped full-module match token.
Its constructor compares the exact full encoding; `for_module` requires the same
immutable Module borrow. The compared encoding also binds CheckedEvaluation, without
serializing it a second time. This token is not persistent or externally constructible;
Store/history authority and the six reuse-premise controls remain separate.
See `evidence/warm-remediation.md` for the actual red/green and scaling-regression evidence.
