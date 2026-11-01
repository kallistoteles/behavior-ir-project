# Action commit bundle ownership: primary-source audit

2026-10-31. Read-only audit of Core research base
`1a3ae37623cf90b4608a678ef283ee313306d9bb` plus guarded typed-record candidate C
in `/tmp/behavior-ir-core-continuation-20261029`. No source edits, builds or
measurements were performed for this audit. Links below name the inspected
source sites; the new experiment should retain its own snapshots and identities.

## Recommended minimal experiment

At the existing final action-record construction stage, after `result_state`
has been computed, evaluate `let bundle_hash = archived_bundle.hash()?;`, move
`archived_bundle` into `TransitionRecord.bundle`, and use the local `bundle_hash`
in that same record. Keep every other hash, validation, backend argument and
public signature unchanged. The current code clones the archive at line 2616,
hashes the archive at line 2618, and has no later use of `archived_bundle`.
[Construction and remainder of function](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2600)

This removes exactly the second complete bundle clone on a fresh action commit.
It leaves the initial `bundle.clone()` in place and does not eliminate the
backend's owned archival copy. `CommitBundle` derives `Clone` and owns its JSON,
maps, vectors, strings and optional evidence/context; `TransitionRecord.bundle`
already owns `Option<CommitBundle>`. Moving this existing owner requires no new
lifetime or shared-mutable representation.
[Bundle definition](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:671),
[record definition](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:892),
[backend storage clone](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/memory.rs:412)

There is an existing analogous ownership pattern in migration assembly:
`bundle_hash: bundle.hash()?` precedes `migration: Some(bundle)`. Migration is a
separate path and need not be changed by this experiment.
[Migration construction](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2891)

## Ownership and exact error boundaries

The incoming `bundle` is borrowed for the full call. The initial archive clone
occurs immediately after the bundle/genesis pairing check. The only assignment
to that archive before final assembly is
`archived_bundle.authorization_context = Some(q)`, after successful trusted
evidence validation and comparison against any caller-supplied archived context.
All rederivation, lifecycle, parent, write and read checks continue using the
incoming borrowed bundle.
[Initial clone and checks](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2185),
[sole archive mutation](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2424)

Hash the **archive**, not the incoming bundle: authenticated v2 commits can add
the independent context only to the archive, and context is a serialized field
of `CommitBundle`. Otherwise the stored bundle and `bundle_hash` could disagree.
The candidate transition identity excludes context and time; the full bundle
hash includes them. These are different identities.
[Context field](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:691),
[candidate content](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:707),
[full hash dispatch](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:752)

Place the new local hash after `check_integrity` and `acc.state_id()`, where the
old hash already occurs. No fallible result-producing operation is crossed by
moving it just before the struct literal: earlier field expressions construct
format/kind strings, clone the head identifier and clone the bundle. This
preserves returned `StoreError` precedence and keeps hashing before the record
hash, accumulator normalization, incremental-child validation and backend CAS.
It intentionally changes allocation/destruction work; no assertion about OOM,
allocation panics or timing equivalence follows from equal typed errors.
[Assembly order](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2600)

Do not replace `CommitBundle::hash` with a raw document hash. The method itself
checks forbidden v2 fields/evidence in v1 and candidate identity/legacy evidence
in v2. `hash_of` materializes JSON and canonical hashing can reject floats.
The same method must still run on the same archive at the same stage.
[Bundle hash checks](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:752),
[materialization](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:225),
[canonical checks](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-core/src/canonical.rs:103),
[hash delegation](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-verify/src/hashing.rs:91)

## Paths that the experiment must preserve

| Path | Source obligation |
| --- | --- |
| v1 fresh action, no evidence or supplied structural evidence | Keep format pairing, transition/module/schema binding, full rederivation and `check_evidence`; preserve late bundle hash refusal of legacy bundles containing v2 semantics. [Entry](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2185), [evidence](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:3310), [bundle hash](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:752) |
| v2 fresh, no evidence | Preserve exact evaluated history and trusted checker; reject context without governed evidence. The move still stores the same archive. [History](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2351), [evidence/context](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2424) |
| v2 fresh, authenticated evidence | `commit_with_context` passes the independent context; validation checks it before copying its JSON into the archive. Hash and store that enriched archive. [Public entry](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:82), [context assignment](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2435) |
| Idempotent/recovered event | Early return occurs before final assembly. Preserve incoming clone normalization for original context, original time and missing evidence, complete bundle/history comparison, original hash, and archived evidence revalidation. This optimization removes no clone on this path. [Recovery](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2238) |
| Invalid/stale candidate | All existing checks and returns before final assembly remain in order; the early archive clone remains. This experiment makes no improvement claim for these calls. [Conflict and validation](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2328) |
| Applied CAS | Preserve record hash, normalized accumulator, child validation, exact versions/removals/references/record/head arguments and carry only after `Applied`. [Final Store boundary](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2629) |
| CAS race/backend error/lost acknowledgement | Keep backend invocation and error mapping; `HeadMoved` reloads actual head and returns conflict; no successful child carry occurs on the other outcomes. [CAS result](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2645) |

The InMemory backend checks its CAS precondition before validating the complete
event/head argument product, recomputes `record.hash()`, validates accumulator,
versions/removals/references/schema, then stores a clone. Preserve that independent
check and copy. For v2, `TransitionRecord::hash` calls `check_kind`, which itself
hashes its contained bundle; neither that nested check nor the backend record
hash is removable merely because the Store just computed a hash.
[Backend boundary](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/memory.rs:348),
[record kind/hash](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/documents.rs:925),
[Backend trait](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/lib.rs:110)

Replay also recomputes full archived bundle identity and compares it with the
event's `bundle_hash`; data replay checks transition and bundle hashes. Retaining
complete event bytes and replay results therefore checks more than comparing
only the evaluated decision returned before commit.
[Archived verification](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/replay.rs:163),
[data replay](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/replay.rs:525)

## Meaningful controls and source-site measurement

Use the retained guarded C as baseline and a candidate containing only this
ownership change. Verify complete decision bytes, complete stored events, bundle
hashes, record IDs, head/history, entity versions, read results, command pages and
data/behavior replay. Include ordinary v1, v2 none-policy, authenticated v2 context
insertion, matching prepopulated context and mismatching context. Assert the
caller's bundle remains unchanged, including context remaining absent when the
stored archive gains it. Existing authenticated-context and recovery tests are
directly relevant starting controls.
[Context tests](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/trusted_governance.rs:357),
[authenticated recovery](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/trusted_governance.rs:525)

Retain invalid evidence, context-required/context-mismatch, forged bundle,
expected-parent/head conflict and compound-error cases with exact code/message
comparison. Exercise ordinary retry, recovery after later commits, differing
retry time, absent retry evidence, mismatched supplied context, prewrite failure,
CAS head movement and lost acknowledgement; verify backend write counts and
durable state/command observations. Existing fault tests cover the relevant
atomicity and publication boundaries, while history tests cover read-only
recovery after later commits.
[Fault controls](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/resulting_state_commit_faults.rs:212),
[lost acknowledgement](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/resulting_state_commit_faults.rs:263),
[later recovery](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/history_integrity.rs:207)

For diagnostics, retain the initial `archive_bundle_clone` scope and independent
hash/backend scopes. A moved-field scope can show its own work but must not be
reported as a remaining clone. Existing document-hash and backend-call counts
should match for each identical fixture; successful fresh commits should retain
all record checks. A source-identified diagnostic clone count can corroborate
two-to-one ownership copies, but semantic controls above remain essential.
Do not add byte-serializing counters to primary timing binaries.
[Original clone scopes](../core-residual-profile-20261031/instrumentation.patch),
[counter perturbation and work counts](../core-residual-profile-20261031/report.md)

The prior representative counter-off N8192 observation partitions the clones as
92.569189 ms for the early archive clone and 44.794706 ms for the event clone
(6.3114% and 3.0541% of that observed commit root). Only the second is directly
removed here. The combined 137.364 ms / 9.37% report group is not the predicted
benefit. These are one instrumented observation, not an uninstrumented speedup
or a bound on changes to later work.
[Exact ranked observation](../core-residual-profile-20261031/analysis.json),
[prior interpretation](../core-residual-profile-20261031/report.md)

Use fresh sequential processes, matched frozen inputs, rotated arm order, exact
binary identities and the same evaluate/commit windows as the retained driver.
Retain first post-commit serialization and a wider process measurement: the
previous study found operation-history-dependent serialization regression,
so a commit gain alone is insufficient for a consumer-level adoption claim.
No cache or allocator mechanism is established by this source change.
[Native driver](../core-typed-record-20261031/profile-driver.rs),
[serialization context evidence](../core-residual-profile-20261031/report.md)

## Nearby alternatives

Deferring the first archive clone until final assembly could avoid it on rejected
or idempotent calls, but would require carrying the validated optional context
separately and changing more ownership stages. It adds no obvious successful
fresh-path clone reduction beyond the recommended move. Keep it separate so the
first experiment has one cause. The incoming borrow and the archive mutation are
the source constraints, not a need for global caching.
[Initial ownership](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2189),
[context mutation](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2452)

V2 constructs `governance_candidate()` once for the early transition identity
check and again for trusted evidence checking. Retaining that same validated
candidate locally is another operation-local reuse question, but it touches a
different phase and only v2. The main fixture uses v1 genesis when commands are
zero, so it would not address this measured clone site. Bundle/record/backend
hash pipelines also perform validation, so broadly skipping repeated hashes has
larger correspondence and error-order obligations than moving one unused owner.
[Early candidate](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2209),
[evidence candidate](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/src/store.rs:2424),
[fixture genesis selection](/tmp/behavior-ir-core-continuation-20261029/crates/behavior-store/tests/support/execution_evidence_fixtures.rs:170)

No better equally narrow reuse target was established in this audit. The event
bundle move is supported by exact local ownership, an already adjacent full hash
and a separately measured clone site, without relaxing any trust boundary.
