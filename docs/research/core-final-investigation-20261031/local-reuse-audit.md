# Fresh action assembly: operation-local bundle hash reuse

2026-11-01. Read-only audit of `/tmp/behavior-ir-core-final-20261031`; no runtime
edits, builds or measurements. This evaluates an additional candidate beyond
the current borrowed document/hash views.

## Recommendation

The proposed reuse is justified as a bounded experiment. Use an opaque,
crate-private `HashedBundle` that owns one `CommitBundle` and the result of
calling that exact owner's `hash()`. Consume it in a private fresh-action event
factory that returns the event and its freshly computed record hash. Preserve
every public document check and the backend's independent event check. This
removes one repeated bundle hash/candidate reconstruction on fresh **v2** action
assembly; it is not proof of commit validity, policy satisfaction, resulting
state validity, backend acceptance or durable publication. Adoption still
requires controls and measured complete-workflow results.
[Fresh assembly](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2600),
[repeated v2 bundle check](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:966),
[independent backend check](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/memory.rs:378)

The source premise is stronger than matching hashes: Store hashes its final
owned archive at line 2606, moves that owner into `record.bundle`, then calls
`record.hash()`. No mutation of that bundle occurs between those operations.
The independently supplied trusted authorization context was already compared
and inserted into the archive at line 2452. Hashing the incoming borrowed bundle
instead would be wrong when that archive gained context.
[Exact owner movement](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2606),
[archive context assignment](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2424)

## Required design invariants

- The constructor consumes `CommitBundle`, runs its existing `hash()` at the
  current late archive-hash stage, and stores both privately. Provide no mutable
  accessor, transport codec, caller-supplied-hash constructor or reusable token
  separate from the owned document. Do not expose a general unchecked hashing
  method. Naming it `HashedBundle` accurately describes its limited fact.
- The consuming factory inserts **that owner** and **that hash** into the new
  action event, with no intervening mutation. A template must not already carry
  a competing bundle, migration or nonempty bundle_hash. Prefer an internal
  action-fields input that cannot represent those fields; if a TransitionRecord
  template is used for minimal code change, enforce/document these preconditions
  and test misuse. Restrict all helper visibility to the smallest useful module/
  crate scope. Never derive an authorization decision from the wrapper.
- Factor current `check_kind` into a private shared helper whose bundle-check
  callback is invoked **only at the present v2-action `b.hash()?` site**. Public
  `check_kind()` supplies the full `b.hash()` callback. Only the consuming
  same-owner factory supplies the already-established-success callback. Keep
  every format/kind match, migration check, missing-history error, history-state/
  parent relation, checked position arithmetic and resulting position check.
- Factor only the existing post-check format dispatch/body hashing into a
  private helper. Public `hash()` must still run full `check_kind()` then this
  body helper. The factory runs the shared kind/history/position checks with its
  exact-owned-bundle fact, then the same body helper. Whole-event canonical
  validation, serialization and hashing still run; this does not reuse the
  record hash or skip checking another event field.
- Consume the fact before returning `(TransitionRecord, record_hash)`. Returning
  a normal mutable event is acceptable only because no retained token can
  authorize subsequent hashing of that modified event. Store must not mutate
  the assembled event afterward. Backend APIs, public hashes and replay receive
  ordinary documents and retain full checking.

These invariants correspond directly to the current two hash entrypoints and
the shared check_kind branches, rather than assuming that a successful hash
establishes all event obligations.
[Bundle hash obligations](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:758),
[event hash/check split](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:931),
[kind/history/position checks](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:957)

## Equivalence and error boundaries

Let `B` be the final owned archive and `H(B)` its existing bundle hash function.
The old fresh assembly computes `h = H(B)?`, moves B into E, then checks E. For
v2 action E that check includes `H(B)?` a second time, discarding its hash output.
Given the first success and the same immutable B, the second invocation has the
same successful result: document hashing uses fixed owned fields and no external
input. Replacing only that repeated success test preserves the later kind,
history, position and canonical event checks. The wrapper establishes identity
by ownership, rather than cryptographic equality or an unverified cache.
[Bundle function](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:758),
[owned bundle fields](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:680)

Keep the first `H(B)` after integrity/state computation and before the event
construction, exactly as today. The crossed field expressions are infallible
construction/clones; do not move that hash earlier than context, timestamp,
integrity or state-accumulator refusals. Retain full public event behavior:
v1 check_kind currently checks bundle format without calling bundle.hash, so
adding a blanket nested hash check would change malformed public v1 acceptance.
The private factory's first bundle hash is justified by Store's existing first
hash, not by changing public v1 rules. Allocation/OOM/panic timing equivalence
is not established by typed result equality.
[Current first-error order](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2600),
[public v1 distinction](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/documents.rs:964)

The normative v2 atomic algorithm archives independently compared Q before
constructing one canonical event, then performs CAS. It does not prescribe
repeating this pure same-owner bundle check during event construction. The
constitution and research spec require complete observations and normative
validation phases, while treating diagnostic/call counts as non-normative.
This proposal keeps the first archive check at the same phase, preserves event
relations, and retains the backend boundary; it does not omit candidate
rederivation or trusted policy checks earlier in commit.
[Atomic phases](/tmp/behavior-ir-core-final-20261031/specs/013-durable-command-intents/contracts/store-and-replay.md:25),
[execution equivalence](/tmp/behavior-ir-core-final-20261031/.specify/memory/constitution.md:101),
[FR-008/009](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/spec.md:122),
[earlier candidate/policy checks](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2424)

Do not extend the shortcut to retry/recovery, public `record.hash()`, migration,
backend commit, replay or incremental-child fallback hashes. InMemoryBackend
checks its CAS precondition, independently recomputes record.hash, then checks
the complete argument product before mutation. Incremental-child promotion has
its own exact-context reuse path and fallbacks; those remain a separate audit.
[Backend ordering](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/memory.rs:348),
[promotion reuse/fallback](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store/incremental/mod.rs:76)

## Red goal and premise-mutation controls

Before implementation, add a source-site diagnostic goal around this fresh
assembly region: v2 currently performs two bundle.hash calls (and their v2
candidate constructions), with exactly one expected after reuse. V1 remains one.
Count only this region so earlier candidate/policy checking and later backend/
promotion checks cannot be accidentally credited as removable. A separate
backend diagnostic must show full record/bundle revalidation still occurs when
the CAS precondition succeeds; HeadMoved must retain its earlier return. This
resource goal should fail on baseline while exact observation controls pass.
[Two local calls](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/store.rs:2606),
[backend precondition](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/src/memory.rs:362)

Require meaningful controls:

1. Compare factory-produced complete event bytes and record hash against frozen
   old assembly plus public `record.hash()`, for v1, v2 none-policy and governed
   v2 evidence/context. Include archival context insertion and unchanged caller
   bytes. Verify a single changed bundle field changes the fresh token result.
2. Prove the first bundle hash still rejects poisoned transition identity,
   legacy-v2 semantics, evidence and floats. Pin compound errors with an earlier
   Store timestamp/context/integrity refusal and later event history/position
   errors, preserving exact variants/messages.
3. Feed wrong event kind/format, previous_record, evaluated_against, committed_on,
   result position and overflow into factory controls after a valid token.
   Every old remaining event relation must still refuse with the old first error.
4. After factory return, mutate the event's bundle record, context, transition
   identity or history. Public `check_kind`/`hash` must fully revalidate; backend
   commit with the old head hash must refuse and publish nothing. A content
   mutation that remains bundle-valid must still change the event hash and fail
   old-head hash comparison. Do not use a mutation test that is blocked only by
   an unrelated earlier format error.
5. Retain direct malformed-v1 public hashing controls, migrations, recovery after
   later commits, wrong-context recovery, prewrite failure, lost acknowledgement,
   CAS race and complete data/behavior replay. A token must never survive a failed
   attempt for reuse with another document or retry.

The affected v2 workload must be measured explicitly: the current no-command
v1 fixture has no repeated v2 nested bundle hash to remove. Keep a v1 comparison
for overhead/regression and the complete-workflow/first-serialization/process
measurements. No saved time or CPU mechanism is established by this source audit.
The added ownership/factory seam is reasonable if its small invariant remains
reviewable and tests show the exact one-call reduction; reject a broader mutable
proof cache or unchecked general event API. If complete-workflow measurements
do not justify the maintenance cost, retain the current fully repeated path.
[Fixture format selection](/tmp/behavior-ir-core-final-20261031/crates/behavior-store/tests/support/execution_evidence_fixtures.rs:170),
[experiment correspondence requirements](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/plan.md:106)
