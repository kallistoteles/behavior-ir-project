# Durable command intents

Core evaluates a transition as T(S,I,C)=Result(ΔS,K,evidence), where K is a finite multiset of immutable typed requests. Evaluation performs no external business I/O. Commit makes ΔS and K durable together; an adapter consumes checked committed occurrences afterwards. A committed request does not assert delivery or success.

## Typed products and guarded bags

Wire IR0.8 declares command products and an action's command_effects bag. Fields use canonical bounded scalar Behavior values, including supported enum/fixed nominal/inert ID/one Option types; entity objects, references, queries, stored Exact and arbitrary blobs are refused. Commands affect BehaviorHash, not persisted SchemaHash. Changing a command alone requires no schema migration.

Each emission contains a declaration, Boolean guard (omitted means true) and payload expressions. The guard evaluates before every payload. False contributes the empty bag, observes no payload dependencies and leaves other action effects available. True constructs one intent or fails the entire evaluation; errors do not become silently omitted commands. Payloads read the exact original S/I/C/facts, never an incidental partially updated state.

Emission order is nonsemantic. Multiplicity is semantic: {A,A,B}={B,A,A} differs from {A,B}. Admission hashes, evaluation/selected errors, semantic trace, proof sites and serialization use canonical emission identity order. Canonical intent ordering implements the bag, without promising external sequencing. Source locations, query binder spelling and equal resolved derived aliases do not distinguish current-profile semantic records; diagnostics are detached. Public declarations, capability names and input binding keys remain semantic. These are specified equivalence laws, not a claim to decide arbitrary program equivalence.

A structurally effectful action may have no state bindings or state effects. Command-only commit preserves StateId/entity revisions/universe and advances history. All-false guards can realize an empty K and still commit a structurally valid transition. No declared state/lifecycle/command effects gives EFFECTLESS_ACTION only under the new profile; legacy rules remain frozen.

## Content and occurrence identity

CommandIntentHash answers what is requested: declaration identity plus canonical typed payload. Equal requests share the hash. CommandOccurrenceId answers which committed occurrence is requested:

    H(behavior.command_occurrence.v1,
      {store, commit_record_hash, intent_hash, multiplicity_index})

The index ranges 0..count-1 among equal intents in that commit. CommitRecordHash already binds parent/position and complete transition/evidence. Copied canonical history agrees; divergent commits at equal position/StateId differ. The derivation is acyclic: intents enter the commit, commit identity derives occurrence identity, and occurrence IDs never enter the commit hash. Replica IDs and source positions are not independent inputs.

## History is the outbox

Store::commands_since accepts a checked request with exclusive full after HistoryRef, optional through (null/omitted captures current head) and max_records1–1024, default256. It returns after, observed_head, items, next_after and complete. It counts whole history events, including empty/migration events, and never splits one commit's multiplicity. History order is semantic; intra-event canonical order promises no adapter execution order.

Only validated committed output constructs opaque CommittedCommand values. Candidate intents have no promotion constructor. Full chain/trust/archive/materialized-state checks precede output; optional indexes do not define membership. max_records limits page events, not full validation work or payload bytes. Reading mutates no checkpoint, history or state. See [performance](command-performance.md) and [persistence](persistence.md).

Adapters own target selection, credentials, retries, checkpoints and delivery status. At-least-once observation with target idempotency may reduce duplicate execution; Core makes no exactly-once external claim. A later explicit invocation records domain results/compensation/correlation. Causal sequencing requires separate transitions around explicit results; see [the payment example](command-results.md).

## Evidence and replay

Authorization binds the whole candidate, including canonical K, through the shared [trusted governance](governance.md). Verification proves only Behavior expression/transition properties; guarded payload safety assumes exactly true guard and canonical prior success. It makes no claim about the external service. Data replay validates archived closed semantic types/intents and authenticated history; Behavior replay additionally rederives exact module/manifests and deterministic output. Neither dispatches, queues, mutates the source or requires external responses.

Admitted legacy IR0.4–0.7 retains bytes, admission/runtime and record identity. Earlier Wire0.1–0.3 remain explicitly unsupported. IR0.8 remains explicit even with empty command arrays. Record0.7 separates semantic evidence from detached provenance; its decoder validates canonical assertions without claiming evaluation took place. Live commit independently re-evaluates before persistence.

## Scope and runnable proof

The [quickstart](../specs/013-durable-command-intents/quickstart.md) runs fixed test keys/time, actual CLI proof/authorization, independent host context, durable commit/stream and a separate-process lost-ack recovery demonstration. This is a tested backend example, not a built-in network adapter. The wider mathematical/security audit remains open; feature acceptance is not a global Core soundness certificate.
