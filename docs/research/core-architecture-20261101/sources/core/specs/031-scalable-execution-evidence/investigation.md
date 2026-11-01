# Scalable Execution and Evidence — investigation results

This research establishes a reproducible cost model and conditional algorithm/correspondence findings for Core 0.16.0. It ships no Core optimization, evidence protocol, persistent authority or lifecycle capability.

Eight creations starting with 8,192 live entities have a **20.984-second median contiguous cycle**, including the final next evaluation. Commit's separate median is **15.943 seconds**. The existing incremental semantic validation succeeds: ordinary predicate evaluations remain **53**, while canonical child-template processing visits **139,328 rows** and named document hashing processes **180.150 MB** of JSON. Remaining growth is therefore broader than repeated semantic predicate checking.

All **96 production-like runs**, **32 separate diagnostic runs** and **32 forced-full reference cases** match exact canonical observations and independent expectations. Three release-mode durable recovery trials also pass. Complete bytes are retained losslessly, with raw repetitions, failed attempts, exact source/binary/tool bindings and explicit limits. The 116.364-MB large-case artifact includes duplicate audit views; its nine cycle decision records total 36.784 MB. These are different quantities.

## Seven-question response index

| FR-001 question | Finding / exact remaining gap | Evidence |
|---|---|---|
| 1. Dominant complete-path costs | Commit dominates the measured warm cycle. Reused templates still construct complete ordered evidence; parse/hash volume grows. Small reads also hash the large committed event. Page/replay/cold paths are measured separately. No per-function allocator/CPU breakdown is claimed. | [Cost model](evidence/cost-model.md), [raw statistics](evidence/baseline/primary-summary.json), [counter scope](evidence/counter-map.md) |
| 2. Necessary versus redundant work | Emitting B old canonical bytes requires Ω(B), but repeated cloning, parsing, hashing and historical reconstruction are not proved necessary. Within-call checked materialization and owned-record/template construction are specific follow-ups; full correspondence and benefit remain unresolved. | [Evidence-processing assessment](evidence/evidence-processing.md), [US2](evidence/us2.md) |
| 3. Independent scaling | Live N, prepared H before a fixed window, changed D, rule/filter complexity and actual payload/evidence bytes each have at least three levels and three production repetitions; one combined fixture exposes interactions. History/page growth differs from warm-cycle growth. | [Coverage](evidence/baseline/assessment.json), [US1](evidence/us1.md) |
| 4. Established algorithm applicability | DBSP, Differential Dataflow and Adapton supply useful algebra/dependency models. Exact pins and verified-scope limits are recorded. No external kernel replay was performed or claimed. A total finite-map count identity has a written arbitrary-finite-state argument and bounded implementation tests. | [Sources](evidence/algorithms/sources.json), [proof scope](evidence/algorithms/proof-scope.md), [correspondence](evidence/algorithms/correspondence.md) |
| 5. Candidate correctness/exclusions | Complete typed deltas, fixed captures, totality, multiplicity, representability, reference/identity rules and exact ordered observations are separate premises. Signed intermediate overflow and partial/lazy queries defeat value-only reasoning. Concrete Core extraction/observation synthesis is unimplemented, so no new Core fast path is certified. | [US3](evidence/us3.md), [native query reference](evidence/algorithms/query-reference-manifest.json), [premise mutations](evidence/algorithms/premise-mutation-results.json) |
| 6. Frozen reference, errors, conflicts, recovery | Baseline modes have zero unexplained byte mismatches. Native errors/refusals and capture/Option/lazy cases, stale competing commits, corruption/missing history, whole-event multiplicity and persisted-before-ack recovery are independently checked. Seven deliberate artifact omissions and five helper-premise mutations fail as required. No optimized engine was executed. | [Artifact controls](evidence/evidence-processing-results.json), [history controls](evidence/history-controls.txt), [recovery](evidence/baseline/recovery-release.json) |
| 7. Old format versus versioned evidence | Lossless physical packing or an internal reuse strategy can preserve old bytes. A logically smaller evidence contract needs explicit interpretation/refinement, completeness, availability, history/profile/migration and governance arguments. A hash or inclusion proof alone is insufficient. | [US4](evidence/us4.md), [interpretations](evidence/compact/interpretations.md), [refinement](evidence/compact/refinement.md) |

## Separate dispositions for all five areas

| Research area | Disposition | Next decision |
|---|---|---|
| Current-format evidence processing | **Unresolved** for a safe acceleration; omission/stale-identity shortcuts **rejected** | Audit/measure concrete clone/parse/hash lifetimes and phase correspondence, then select one isolated patch |
| Broader incremental queries | Conditional finite-map value reasoning **supported by evidence**; complete Core optimization **unresolved** | Start with total local filtered count, authoritative typed deltas/captures and full reference fallback; preserve all observations |
| Compact verifiable evidence | Three interpretations **unresolved**; state-hash/returned-members-only shortcuts **rejected** | Establish a versioned complete interpretation and its verification/availability/trust contract before implementation |
| Historical verification | Repeated-prefix mechanism measured; acceleration **unresolved** | Assess within-call checked materialization first; cross-call anchors/checkpoints have additional freshness/corruption burdens |
| Bounded live-state lifecycle | Existing authorized removal **supported**; generic bounded capacity **unresolved** | Separate domain cleanup/refinement and historical/backend retention decisions; no automatic cleanup |

[US5](evidence/us5.md) separates historical verification from retention. A one-record command page grows from roughly 1.971 to 9.653 seconds as prepared H grows 8→128 at fixed live population, while its payload remains about 1.6 KB. A retention control leaves one live entity but nine historical identity candidates and sixteen replayable events. A small response or live set does not establish bounded verification/storage work.

## Correctness, proof and trust classes

- **Written mathematics:** finite-map partition/cancellation and conditional interpretation/correspondence arguments. They are not newly machine-checked Core theorems.
- **External formal artifacts:** exact primary-source inspections and publisher claims, with explicit Lean/tool/dependency/admission qualifications. No independent elaboration, axiom audit or kernel replay is claimed.
- **Implementation evidence:** exact full-reference/production/diagnostic bytes; independent native outcomes; 729 state pairs; five compiled substantive premise mutations; artifact tamper controls; public Store/replay/recovery tests and existing gates.
- **Remaining trust:** Core/Rust implementation and extraction, cryptographic/toolchain/backend contracts, complete snapshots/history availability, trusted context and host authorization. A hash establishes identity, not mathematical validity or deployment permission.

The finite-map helper independently checks its supplied complete resulting map, so its full construction/check remains O(N), even though the arithmetic update is O(D). It does not independently extract actual Core effects, establish all captures/policies or synthesize every Core trace. This separates a sound conditional formula from an end-to-end optimized verifier.

## Ranked follow-ups, separately scoped

1. **Within-call historical materialization reuse.** Benefit: potentially remove repeated authenticated prefix reconstruction while preserving existing bytes. First establish exact version/policy/migration/error-phase correspondence and measure full page/rebuild costs. Deferred implementation; no persistent authority approved.
2. **Native evidence/record construction and local reuse.** Benefit: reduce intermediate template/JSON ownership and repeated checked serialization/parse work in the dominant cycle. Needs allocation/per-site CPU attribution, exact immutable input/context binding and owned-public-output correspondence. Deferred isolated implementation proposal.
3. **Total local filtered-count maintenance.** Benefit: extend semantic-validation coverage using the established count identity. Needs complete admitted-IR extraction, captures, representability and observation/error mapping; it will not alone remove current output/hash costs. Deferred implementation with ordinary fallback.
4. **Versioned compact evidence/checkpoints.** Potentially change the long-term logical output/replay cost model. Requires complete interpretation/refinement, independent verification, availability and compatibility decisions. Research finding only.
5. **Retention/backend profile.** Existing removal can reduce live evidence, but historical versions, identity nonreuse, reference integrity and replay availability remain. A bounded-lifecycle/storage claim needs a separate domain/backend contract and measurements.

None of these recommendations automatically authorizes a production change. Reusing a complete engine or adding a general framework is not justified by this investigation.

## Attempts, capacity and reproducibility

The initial 120-second N=8192 reference preparation timed out before returning a complete multi-path result. The full group was rerun under an explicitly related 300-second operational limit, with the 8-GiB AS bound unchanged. Earlier inputs, source/binaries and failure remain in [lineage](evidence/baseline/lineage.json). Collector provenance checks were strengthened before primary collection; primary execution uses its archived exact source. No slow repetition was replaced.

Other retained setup failures include an incorrect retry-time test assumption, wrong legacy read-error envelope, a test-startup timeout and Clippy type readability. They are not Core counterexamples or successful proof-premise mutations. The actual substantive mutation results are indexed separately.

The measured backend is the in-memory reference backend. Peak memory includes retained audit data; reopen clears Store caches while preserving backend indexes; durable recovery is a small cooperating-local-filesystem fixture. OS cache and physical host exclusivity are not controlled, so ranges and environment are retained. No universal delta-proportional bound, production fsync/network SLA or complete backend rebuild result is claimed. External/private application tests were unnecessary.

Follow [quickstart](quickstart.md) for exact build/freeze/collect and bounded-smoke commands. The [portable corpus](evidence/portable/index.json) recovers 297,067,492 exact observation bytes from 9,981,233 gzip bytes and includes a checked source archive; this is research transport, not a new Core evidence format. Final code/compatibility gates and SC-001–006 validation are indexed by [completion](evidence/completion.json).
