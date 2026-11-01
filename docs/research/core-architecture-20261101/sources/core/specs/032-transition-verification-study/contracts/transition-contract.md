# Common transition and maintained-meaning contract

**Contract**: `core032.transition.v1`. Governs reference, A, B and the semantic relation proved in the bounded accumulated experiment.

## 1. Exact meaning

Let Ω contain live state, lifetime-used IDs, exact lineage and applicable module/schema/profile. Let I contain the request/bindings/context and required publication inputs. Define the deterministic reference:

`F_M(Ω,I) = (semantic_outcome, Ω_candidate, canonical_commands, selected_error, normative_observations)`.

Successful publication is a separate compare-and-set against the exact parent/history. Refusal/error produces no commit. A conflict requires re-evaluation at the new parent; an old valid witness is not a new commit authorization.

For existing profiles, candidate equality includes exact canonical output bytes and relevant Core error/phase semantics. For `core032.study-observation.v1`, require a reviewed interpretation `Expand(support, compact)` whose full observation equals the reference. A formal compact-model expansion theorem does not prove the Rust canonical serializer; inventory that correspondence separately. Deferred export is permitted only when all promised observations can actually be reconstructed.

## 2. Closed public model and scope

Use an admitted parameterized module with ordinary E rows (`x`, auxiliary values), positivity `x > 0`, a genuine population cap L, Parent rows and required typed references in reference cases. Add literal assignment/create/remove, a command-only action and canonical command multiplicity. Parameterize captured input predicates with a threshold for query/context and high-fanout controls.

Check the entire admitted module against the recognized fragment. An extra action/effect/invariant, ambiguous binding, unsupported operator or unaccounted context is not silently ignored. Native candidates may use exact reference fallback. A proof claim cannot certify a fallback unless that computation is also within the claimed relation; otherwise it reports Unsupported for that case.

Distinct fixture families share this model template:

- **Boundary**: L=1000; start at 999, accept creation 1000, refuse 1001 with exact Core outcome/observations.
- **Scaling**: L is increased and frozen with each case so populations 2048/8192 are valid. Do not benchmark invalid genesis against L=1000.
- **References/lifetimes**: parent removal with surviving references; valid unreferenced removal; child removal; aliases; used-ID reuse after removal, including equal live state with different lifetime histories.
- **Context/fanout**: captured threshold changes membership of many rows, including transitions from empty to nonempty. Unknown coverage is conservative.
- **Errors**: checked overflow, partial values, lazy skipped error and canonical first-error/subject ordering, supported only when all semantics are represented.
- **Commands/history**: duplicate equal intents, canonical occurrences, command-only commit, refusal without commit and lost acknowledgement of an actual persisted event.

Independent hand oracles freeze expected outcomes/counts/positions, not just equality of two implementations. An increment 0→2 example remains wrong even if it satisfies a selected safety rule.

## 3. Candidate A: inductively maintained exact meaning

Define J as exact query membership/count, reference inventory and retained outcome equality at the full semantic/context coordinate. Required mathematical results:

```text
init_correct: successful checked initialization establishes J
maintained_correct: J ∧ supported input ⇒ result_A = F_M ∧ J_next
rebuild_correct: complete authoritative reconstruction establishes J
```

The theorem must cover refusals/errors without corrupting views. Invalidation includes absences, newly matching rows, deleted targets, changed captures and all state-changing operations. Producer enumeration cannot certify completeness. Rules whose affectedness is unknown are recomputed or fall back. Finite caches without this relation are not certified incremental execution.

## 4. Candidate B: independent witness checking

B takes exact input/accepted anchor, a proposed observation and untrusted witness. Its initial implementation reads full bounded snapshots/lifetime inventory; it cannot trust A's prior J. Require:

```text
checker_sound: Accepted_B(anchor, input, result, witness) ⇒ result = F_M(Ω,I)
checker_complete: supported input ⇒ a complete witness for F_M(Ω,I) is accepted
```

Establish exact anchor/snapshot correspondence, sorted unique identity coverage, all operations/obligations, selected errors, command occurrences and unchanged-state coverage. A root hash or private producer type is insufficient. A complete-looking input snapshot must still be bound to an independently accepted anchor.

InvalidWitness, Unsupported and exhaustion are checking outcomes, never semantic refusal. If a native adapter promises fallback, compare that path byte for byte with the reference. Checker completeness is relative to the declared supported fragment, not arbitrary Core properties.

## 5. History, initialization and recovery

Prove composition of exact finalized transitions from a valid exact anchor. Attempt count can advance on refusal; committed history position cannot. Command-only ALLOW advances history even with unchanged content. Reusing an identity removed long ago requires lifetime history, not merely the live snapshot.

Module switching/migrations are excluded from the initial proof relation. A new segment requires a new exact anchor and appropriate validation; no claim is inherited merely from a shared schema. Governance/authorization and physical execution remain separate.

Lost acknowledgement recovery must identify the already committed event and canonical commands from retained history. It must not create a duplicate commit or dispatch commands during replay. Cold loss of views requires authoritative reconstruction before reuse.

## 6. Evidence classes and test obligations

Machine-check F/J/K and supported history composition in Lean. Keep Core-to-model extraction, Rust implementation/renderer and circuit translation assumptions explicit. Differential/property/mutation tests against actual Core supply correspondence evidence, not universal proof.

Before new acceptance code, retain red controls for missing/extra memberships, stale counts, omitted assignments/actions, incorrect refs, incomplete used IDs, changed context and wrong outputs. Deliberate mutations target the actual checker/reuse path. Typed JSON comparisons distinguish booleans from numbers. Unsupported expression placement cannot be treated as a known safe canonical form.
