# Core 029 evaluation report

Production source: `919429b3f1bd7185a51c7c5fa9cb24c474229192`. The complete required G3 gate passed before this campaign. The unchanged frozen-profile evaluator accepts all 103 cases and the growth criterion; see [acceptance.json](evidence/acceptance.json). This is platform/workload evidence, not a universal complexity or formal implementation proof.

## Corpus, controls and measurement scope

927 retained rows cover 103 unique cases: released baseline and candidate each have three production-like repetitions plus one instrumented run; every case also has one independently forced full-reference instrumented run. All five groups match the frozen complete-observation digest and byte size. The baseline is immutable Core 0.15.0 source; candidate/full-reference use the exact gated source. Final collection retains all three timing repetitions per case, every absolute budget, local/fallback median envelope and required primary/growth improvement. No diagnostic time determines acceptance.

Each creation case performs eight real committed transitions in one continuously growing Store, followed by the final next-evaluation drain. Starting populations are 1, 16, 128, 512, 2048 and 8192. The corpus also varies fixed-population history (8/32/128 commits), simultaneous creates (2/8), global-rule counts (1/4), unrelated-type population growth, no-global/constant/unsupported rules, same-head warming and reopening. The independently expected creation 1000 ALLOW / creation 1001 DENY boundary is a separate correctness test, not inferred from the positive timing corpus.

The reference platform is x86_64 Linux with eight visible CPUs, nominal Xeon X5670 at 2.93 GHz and approximately 23.4 GiB visible RAM. Probes use CPU 0; auxiliary orchestration/analysis uses CPU 1. Public baseline/candidate timing and work probes each use a fresh process/Store. The forced-full reference uses fresh Stores sequentially inside one Rust test process; its per-case outer elapsed includes framing and its HWM is cumulative diagnostic information. Reference timings/HWM do not determine production acceptance. Filesystem cache is not flushed. Installation/build time is outside the clocks. `total_ms` covers the complete evaluate/commit loop and final evaluation; setup, reopening, process wall and process HWM have separate frozen limits. Process wall includes post-clock canonical output auditing, startup and reporting. HWM includes retained audit observations. Exact tools, locks, flags, binaries, source and resource conditions are in the [manifest](evidence/campaign-manifest.json), [profile](evaluation-profile.json) and [raw rows](evidence/scaling.jsonl).

## Mandatory affected creation growth

Tables compare the complete final released-baseline and candidate groups. Numerical acceptance uses the earlier G0 frozen envelopes and baselines, which may differ slightly from these later measured comparison medians.

| Starting entities | Baseline median cycle ms | Candidate median (min–max) cycle ms | Reduction | Audit observation bytes |
|---|---|---|---|---|
| 1 | 28.722 | 29.600 (29.542–30.022) | -3.1% | 40324 |
| 16 | 68.097 | 55.158 (54.560–55.793) | 19.0% | 104539 |
| 128 | 360.563 | 261.293 (260.639–266.818) | 27.5% | 587379 |
| 512 | 1503.849 | 1078.173 (1062.856–1095.020) | 28.3% | 2253172 |
| 2048 | 6365.220 | 4697.857 (4450.168–4785.446) | 26.2% | 8954077 |
| 8192 | 26870.894 | 19106.547 (18955.673–20049.803) | 28.9% | 35827933 |

The measured 512→8192 count-create slope is 2.347445 ms per starting entity, versus the frozen baseline 3.402740 ms per starting entity; it satisfies the required ratio≤0.90. These are finite measured slopes, not a bound for arbitrary modules. Primary count create/update/unrelated cases and constant-update controls at 512, 2048 and 8192 each satisfy their separate median≤90% baseline requirement.

Audit bytes include complete normative records, commits and head inside a nonsemantic measurement envelope. They are not a new Core record format.

## Whole-cycle phase attribution

| N / route | Strategy | Evaluate ms | Commit ms | Final evaluation ms | Setup ms | Complete cycle ms |
|---|---|---|---|---|---|---|
| 512 / count-create | released-baseline | 382.266 | 1052.581 | 49.082 | 148.761 | 1503.849 |
| 512 / count-create | candidate | 217.565 | 810.929 | 28.657 | 183.853 | 1078.173 |
| 8192 / count-create | released-baseline | 6695.345 | 19040.872 | 856.733 | 2439.487 | 26870.894 |
| 8192 / count-create | candidate | 3712.848 | 14638.912 | 499.790 | 2940.685 | 19106.547 |

Columns are separately computed medians and need not sum exactly. Contiguous total time is the acceptance quantity. The final drain ensures child validation is not merely deferred outside the measured loop.

| N=8192 rule | Workload | Baseline cycle ms | Candidate cycle ms |
|---|---|---|---|
| none | create | 26520.876 | 17157.893 |
| none | update | 27067.920 | 15347.540 |
| none | unrelated | 26606.649 | 17935.514 |
| none | warm | 5825.563 | 4094.384 |
| true | create | 25449.029 | 18638.845 |
| true | update | 25027.333 | 15674.194 |
| true | unrelated | 25283.821 | 17628.707 |
| true | warm | 5718.159 | 3964.475 |
| count | create | 26870.894 | 19106.547 |
| count | update | 27063.425 | 17865.274 |
| count | unrelated | 27028.554 | 19194.868 |
| count | warm | 6612.022 | 4672.006 |
| unsupported | create | 27074.554 | 23702.589 |
| unsupported | update | 27836.717 | 23051.476 |
| unsupported | unrelated | 27214.307 | 25042.726 |
| unsupported | warm | 6741.175 | 6333.881 |

## Semantic work versus output-sized work

Instrumented count-create at N=1:

| Named work counter | Released baseline | Candidate | Full reference |
|---|---|---|---|
| snapshot_rows | 125 | 0 | 162 |
| decoded_rows | 735 | 1 | 809 |
| predicate_evaluations | 346 | 53 | 392 |
| provider_rows | 81 | 0 | 81 |
| query_rows | 81 | 0 | 81 |
| store_value_rows | 206 | 0 | 243 |
| child_rows | 81 | 81 | 81 |
| copied_rows | 243 | 0 | 243 |
| backend_enumerations | 16 | 0 | 34 |
| backend_key_candidates | 88 | 0 | 162 |
| backend_members | 44 | 0 | 81 |
| backend_versions | 70 | 26 | 107 |
| backend_record_reads | 23 | 23 | 30 |
| backend_commits | 8 | 8 | 8 |
| hash_document_json_bytes | 235193 | 235193 | 276850 |

Instrumented count-create at N=8192:

| Named work counter | Released baseline | Candidate | Full reference |
|---|---|---|---|
| snapshot_rows | 204900 | 0 | 278656 |
| decoded_rows | 1245767 | 1 | 1393279 |
| predicate_evaluations | 483615 | 53 | 557380 |
| provider_rows | 139328 | 0 | 139328 |
| query_rows | 139328 | 0 | 139328 |
| store_value_rows | 344228 | 0 | 417984 |
| child_rows | 139328 | 139328 | 139328 |
| copied_rows | 417984 | 0 | 417984 |
| backend_enumerations | 16 | 0 | 34 |
| backend_key_candidates | 131144 | 0 | 278656 |
| backend_members | 65572 | 0 | 139328 |
| backend_versions | 65598 | 26 | 139354 |
| backend_record_reads | 23 | 23 | 30 |
| backend_commits | 8 | 8 | 8 |
| hash_document_json_bytes | 175992671 | 175992671 | 207580542 |

Every selected non-reopen none/true/count case satisfies zero full snapshot rows, provider rows, query-row decoding and Store value-query rows, plus the frozen bounded decoding/predicate criteria. Independent allowed-typed-key controls additionally require zero unrelated typing/rule checks throughout evaluate, commit and drain. All applicable roots and actual simultaneous effects remain covered. The full-reference route reconstructs complete parents and children, so this is not agreement with a partially cached reference.

Root cause: global roots previously defeated promotion of established whole-state validity. Subsequent evaluations reconstructed and rechecked live state; the ordinary action/commit paths also repeatedly decoded and checked complete unchanged child rows. Merely retaining a parent cache did not remove that work. Core-owned checked state now supplies exact typed membership and eligible unchanged-row observer templates; actual changed/created rows retain ordinary checks. Count advances from actual distinct fresh creations with checked arithmetic. Exact successful CAS alone advances the context.

Remaining costs: normalized complete cached universes still must be traversed/emitted where the current record contract archives them; exact query member IDs and per-child trace rows remain output-sized. Record construction/ownership, strict parsing, complete comparison, required commit hashing and history lookup therefore retain work tied to evidence/history size. `child_rows` counts both required evidence visits and active row checking; it must not be interpreted as repeated semantic rule evaluation. `copied_rows` covers named collection-copy sites, not every allocation; `hash_document_json_bytes` is document JSON size at named hashing sites, not all hash-domain bytes. Full-reference/backend counters describe this controlled backend and do not prove every host has identical costs. The output-size floor does not prove that each current copy/parse/allocation is optimal. Remaining record-processing overhead can be improved separately; it is not equivalent unchanged-row semantic revalidation moved outside the clock.

## Interactions, fallback and diagnostic overhead

| Case (N,steps,rule,operation,batch,rules) | Baseline cycle ms | Candidate cycle ms |
|---|---|---|
| (128, 8, 'count', 'update', 1, 1) | 376.951 | 262.126 |
| (128, 32, 'count', 'update', 1, 1) | 1497.963 | 1021.632 |
| (128, 128, 'count', 'update', 1, 1) | 6043.808 | 4198.409 |
| (512, 8, 'count', 'create', 2, 1) | 1472.716 | 1010.889 |
| (512, 8, 'count', 'create', 2, 4) | 1541.633 | 1057.955 |
| (512, 8, 'count', 'create', 8, 1) | 1594.530 | 1141.507 |
| (512, 8, 'count', 'create', 8, 4) | 1687.839 | 1214.550 |
| (128, 8, 'count', 'reopen', 1, 1) | 542.595 | 492.320 |

Candidate diagnostic/production-median timing ratios across 103 cases range 0.897–1.141, median 1.040. One diagnostic observation per case is not a clean causal overhead estimate: scheduling/allocator variability can yield ratios below1. No ratio is subtracted or used to pass a numerical budget. Modes have identical complete semantic digests/bytes.

## Preserved failures and remediation

The first gated candidate 1cfec65 failed N2048 count-create (median 6167.384 ms, required≤5740.302 ms); its 709 completed rows remain in `evidence/attempts/campaign-1cfec65`. A red/green work test identified duplicate complete-record parsing, parent establishment and child hashing at promotion. Native commit now passes its own already checked identities; full record reproduction and exact child CAS remain mandatory. G3 was renewed after that correction. See [promotion remediation](evidence/promotion-remediation.md).

An unisolated b873d80 attempt exceeded a small absolute cycle budget (28.323 ms versus26.720 ms), and its 505 complete rows remain in `evidence/attempts/campaign-b873d80-unisolated`. Its exact cause is unknown. Auxiliary commands shared an inherited CPU set including the measurement CPU. One complete controlled repeat was declared and performed with auxiliary commands on CPU 1 and unchanged measurement CPU 0, code, binaries and thresholds. No individual case/repetition was replaced. That controlled repeat then exposed stable small same-head median regressions (none/true/count); its 703 completed rows remain in `evidence/attempts/campaign-b873d80-controlled`. An actual failing counter control identified two full module encodings per evaluation. The new private immutable-borrow token retains the exact full-content match and moves the same encoding into checked evidence; it removes the duplicate encoding. All six mutations, Core/Store controls and full G3 were renewed. See [small-case remediation](evidence/warm-remediation.md). Final acceptance uses every new candidate/reference row from that corrected gated source, with the same frozen criteria; none of these failed attempts is described as passing. The complete released-baseline groups were reused with their exact saved binaries/toolchain/harness; no old candidate results entered final acceptance.

The 446c55c campaign also failed an absolute small unsupported-create budget (44.054529 ms versus41.6021875 ms); all 702 completed rows remain in `evidence/attempts/campaign-446c55c`. The cause of that third-run variation is unknown. Independently, stable extra fallback commit overhead was traced to promotion parsing/hashing and parent rereading before returning no evidence. An actual failing control counted one unnecessary parent read. A conservative union of 015 locality and 029 coverage now restores early fallback, leaving ordinary evaluation/reproduction/commit authoritative. The new 41-test Store control and Clippy pass, followed by renewed full G3. Core mutation source is unchanged. See [fallback remediation](evidence/fallback-remediation.md). All final candidate/reference rows are fresh for the corrected source; no threshold or individual case was replaced.

The complete 0d6a52c campaign contains 927 rows with every semantic/work/primary/growth check passing, but unsupported/warm/N8192 misses its frozen median limit (7297.947899 ms versus7162.4556506 ms). The complete failed campaign remains in `evidence/attempts/campaign-0d6a52c`. A predetermined paired experiment isolated ordinary-result allocation lifetime and row-helper inlining, alone and combined. Keeping the original Core DecisionRecord alive through bundle construction, as before 029, reduced the median from 7361.927984 ms to 6259.275894 ms with identical complete observations. Inlining alone did not materially help and is not retained. Only the original allocation lifetime was restored; Core source/premise-mutation SHA remains unchanged. See [allocation-lifetime findings](evidence/fallback-lifetime.md). Full G3 and every final candidate/reference group were renewed for the corrected source, with no threshold changes.

## Correctness, compatibility and limitations

Full G3 passed 1,791 Rust tests across 236 result groups (0 failed; 30 explicitly ignored), plus script gates, immutable archives, consumer, public surface and determinism. Complete positive/negative/error comparisons, six actual premise mutations, exact module/history/profile boundaries, conflicts/migration/reopen and a separate-process persisted-but-unacknowledged commit remain covered. [The conditional argument](correctness.md) distinguishes mathematical reasoning from tests and trusted Rust/Backend correspondence. No machine-checked implementation proof is claimed.

Supported optimization: current live `Store::evaluate` →commit→next evaluation; literal Boolean globals and exact typed unfiltered count upper bounds, classified local entity rules, updates and fresh creation. Memo-bearing local derived rules keep ordinary observer computation. Unknown/mixed roots, removals and migrations select ordinary authoritative paths. Unified invoke, declared reads, arbitrary filtered/relational queries and historical replay retain existing paths and have no timing guarantee from this corpus. Cold validation/setup remains full work and is measured separately. Other backends/workloads may have different dominating costs.

Core IR, canonical/historical record formats, semantic identities, Backend requirements, governance and replay dependencies are unchanged; see [compatibility audit](evidence/compatibility.md). Prepared state is reconstructible and ephemeral. This establishes a measured material improvement for the selected growing creation case and removes repeated unchanged-row semantic validation there; it does not promise constant-time transactions, all-global incrementality, unlimited capacity, private-application remediation or an unexecuted 30-minute endurance run.
