# Serialization conclusion: independent evidence audit

2026-11-01. Read-only interpretation of the verified primary and supplemental
factor cohorts. No frozen artifact/source edits, builds, tests, producer runs
or measurements were performed. Selected sink/charged-cost contrasts were
also recomputed directly from retained process rows. PMU diagnostics are a
separate pending investigation; no physical attribution is made here.

The evidence supports retaining the final view candidate V for the measured
complete consumer workload, rejecting preparatory input touch as a mitigation,
and treating a presized direct writer as an additional consumer-specific
serialization option. It does **not** support claiming every serialization
phase improves or that buffer growth alone explains every first-call result.

## Cohorts and comparison rules

Primary verification covers 550 processes: native/full observations, initial
sink factors and historical anchors. Supplemental verification covers 560
fresh processes, 4,480 serializer rounds and 80 complete representative
outputs. All required complete bytes match in their respective verified
cohorts. [Primary verification](primary-verification.json),
[factor verification](factors-verification.json).

A denotes the decode-reuse reference, C the guarded typed candidate, M the
archive-move candidate and V the final view candidate. Original O is the
earlier research base used by the complete native comparison and command-v2
follow-up. A and O are different references. Percentages below are ratios of
within-cohort process medians. Slower-pair counts compare corresponding
repetitions out of seven; they are distinct from the median ratio.

Each total is summed inside its process before taking the median. Separately
reported setup/write medians are diagnostic observations and must not be
added to reconstruct a median total, or used to claim a precise percentage
decomposition. Cohorts retain distinct prefixes, binaries/drivers and timing
contexts; their absolute times or percentages are not pooled.

## The native operational result, including its adverse phase

For V versus original O, all six native consumer medians and wider process
medians improve, with **zero slower pairs in each of those comparisons**:

| N / commands | First Display: O → V ms | First Display change; slower pairs | Evaluate+commit+Display change; slower pairs | Wider process change; slower pairs |
| --- | --- | --- | --- | --- |
| 128 / 0 | 1.161659 → 0.912046 | −21.49%; 1/7 | −26.80%; 0/7 | −13.64%; 0/7 |
| 512 / 0 | 5.753176 → 2.461509 | −57.21%; 0/7 | −27.72%; 0/7 | −10.48%; 0/7 |
| 2,048 / 0 | 10.961314 → 9.825861 | −10.36%; 0/7 | −29.44%; 0/7 | −12.77%; 0/7 |
| 8,192 / 0 | 37.903432 → 34.725220 | −8.39%; 0/7 | −30.82%; 0/7 | −13.82%; 0/7 |
| 128 / 2 | 0.733527 → 0.921789 | **+25.67%; 7/7** | −22.06%; 0/7 | −15.53%; 0/7 |
| 512 / 2 | 3.041048 → 2.514097 | −17.33%; 0/7 | −22.21%; 0/7 | −16.44%; 0/7 |

The N128 command-v2 phase regression is 0.188262 ms between medians. Its
complete native consumer improves from 126.543237 to 98.629991 ms, but that
larger gain does not erase the reproducible phase regression.
[Native process results and pairs](native-analysis.json).

Historical-shaped anchors also preserve the earlier C/A regression: N128
1.082541 → 1.212521 ms, **+12.01%, 7/7 slower**; N512 5.758661 → 6.094959 ms,
**+5.84%, 6/7 slower**. V/A improves first serialization by 14.41% and 56.04%
at those populations, with 0/7 slower pairs in each. These separately retained
anchors prevent an expanded probe prefix from silently redefining the old
result. [Anchor results](anchors-analysis.json).

## Capacity sensitivity is established; a universal growth explanation is not

In the primary N512 legacy sink cohort, C/A first-call changes are:

| Sink | O1 total change | Slower pairs |
| --- | --- | --- |
| Display | +10.35% | 7/7 |
| to_vec | +12.19% | 7/7 |
| writer128 | +14.24% | 7/7 |
| writer-full | −0.17% | 4/7 |

The presized direct writer removes this median regression in that context;
four slower pairs make −0.17% inappropriate evidence of equivalence or a
reliable small gain. The source changes both sink and initial capacity across
these modes. [Primary sink results](sinks-analysis.json).

The supplemental matched Display comparison addresses that confounding. At
N512 legacy, sham C/A is **+10.17%, 7/7 slower** with Display128 and **−4.87%,
2/7 slower** with Display-full. Its full-buffer write interval alone is
**+1.65%, 5/7 slower**; setup is **−11.04%, 2/7 slower**. Thus the observed
large C/A gap depends on capacity policy within the same Display formatter
entrypoint, while smaller adverse write observations remain.

This is not a universal preallocation benefit: within A, full Display versus
Display128 changes total by **+1.52%, 2/7 slower**; within C it changes by
**−12.34%, 1/7 slower**. Within V the same contrast is only **−2.23%, 1/7
slower**, with a **+1.29%** complete first-consumer median and 4/7 slower
consumer pairs. [Matched capacity results](factors-analysis.json).

Much of the broad A/C/V difference is already observable before the first
write. These are supplemental N512 legacy sham medians, each reported
independently:

| Arm | Full Display setup ms | Full Display write ms | Full Display total ms | Full writer setup ms | Full writer write ms | Full writer total ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A | 3.428574 | 2.357135 | 5.780488 | 3.259040 | 1.238780 | 4.680277 |
| C | 3.050030 | 2.396108 | 5.499143 | 3.078946 | 1.213845 | 4.305155 |
| V | 0.120881 | 2.286704 | 2.408510 | 0.129483 | 1.199011 | 1.331383 |

For full writer, V/A setup changes **−96.03%, 0/7 slower**, write **−3.21%,
1/7 slower**, and observed total **−71.55%, 0/7 slower**. The pre-write interval
contains dispatch, allocation, capacity inspection and a clock call; these
measurements localize elapsed work without identifying an allocator routine,
kernel path or CPU mechanism. Primary full-writer setup medians show the same
broad ordering A3.158749/C3.150300/M0.760971/V0.120764 ms, but remain their own
cohort. [Factor intervals](factors-analysis.json),
[primary intervals](sinks-analysis.json), [source boundary](serialization_factor.rs).

## The N128 command-v2 regression survives presizing

In the supplemental sham cohort, V/O first-call total is adverse with every
tested sink and **all seven pairs**:

| Sink | O → V total ms | Change |
| --- | --- | ---: |
| Display | 0.670989 → 1.028773 | +53.32% |
| Display128 | 0.669838 → 1.035987 | +54.66% |
| Display-full | 0.651546 → 1.013529 | +55.56% |
| writer-full | 0.355920 → 0.736540 | +106.94% |

This independently reproduces the adverse direction, with a different
cohort-specific magnitude from native +25.67%. Presizing does not eliminate
that arm comparison. Full Display setup is O0.039240/V0.390743 ms, **+895.78%,
7/7 slower**, while write is 0.613251/0.620289 ms, **+1.15%, 5/7 slower**.
Full writer setup is 0.039106/0.403400 ms, **+931.56%, 7/7 slower**, while write
is 0.316814/0.323702 ms, **+2.17%, 4/7 slower**. The large percentage setup
changes have small absolute baselines; retain both units.

All four sham sink modes still show V/O complete first-consumer median gains
of 21.50–22.36%, with 0/7 slower consumer pairs each. That supports the bounded
complete-workload recommendation, not a claim of uniformly improved phases.
[Command-v2 factor results](factors-analysis.json).

## Read-only touch is a diagnostic, not a useful mitigation here

The preparatory walk often improves later writing but costs more than it
saves. Across **all 40 arm/case/sink cells**, touch+O1 median is worse than
sham+O1: **+11.53% to +40.61%**, with **278/280 matched pairs slower**. The
only exceptions are one N128 legacy V Display pair and one N128 command-v2
O Display128 pair. This directly rejects adopting the tested traversal as a
latency mitigation; a complete consumer total dominated by other phases
must not conceal its marginal serialization cost.

Illustrative V comparisons, all from the supplemental cohort:

| N / commands / sink | O1 total: sham → touch ms | O1 change; slower pairs | Touch+O1: sham → touch ms | Charged change; slower pairs |
| --- | --- | --- | --- | --- |
| 128 / 0 / Display | 0.924537 → 0.888964 | −3.85%; 1/7 | 0.924691 → 1.059787 | +14.61%; 6/7 |
| 512 / 0 / writer-full | 1.331383 → 1.011744 | −24.01%; 0/7 | 1.331528 → 1.853165 | +39.18%; 7/7 |
| 128 / 2 / writer-full | 0.736540 → 0.640578 | −13.03%; 0/7 | 0.736672 → 0.873043 | +18.51%; 7/7 |
| 512 / 2 / Display | 2.537813 → 2.205226 | −13.11%; 0/7 | 2.537918 → 3.103013 | +22.27%; 7/7 |

Full-writer N512 legacy setup remains very different after touch:
A4.131758/C4.106432/V0.136588 ms. It also changes relative to sham despite
the walk making no heap calls. That behavior is consistent with the bounded
H4 persistence question, while invalidating any assumption that an
allocation-free traversal cannot affect subsequent setup latency.
[Touch contrasts and charged process sums](factors-analysis.json).

## Original repeats and parsed controls bound the first-call interpretation

The current primary campaign does **not** reproduce the earlier campaign's
faster-C repeat/parsed medians. At N512, C/A original-repeat medians are
2.20–4.62% slower across the four initial sinks; parsed-repeat medians are
3.01–4.46% slower. For primary Display specifically: O1 **+10.35%, 7/7
slower**; original repeats **+2.92%, 6/7**; P1 **+4.98%, 5/7**; parsed repeats
**+4.46%, 6/7**. The older favorable repeat results remain valid evidence of
their own campaign, not an invariant explanation of this one.
[Current primary sink results](sinks-analysis.json),
[older context campaign](../core-residual-profile-20261031/report.md).

The supplemental N512 legacy sham Display observations show the large
first-call effect shrinking substantially on later calls:

| Arm | O1 ms | Median original repeats ms | P1 ms | Median parsed repeats ms |
| --- | ---: | ---: | ---: | ---: |
| A | 5.591018 | 1.967228 | 2.099701 | 2.020610 |
| C | 6.349680 | 2.034952 | 2.188102 | 2.115637 |
| V | 2.499720 | 1.955450 | 2.193010 | 2.055285 |

C/A O1 is +13.57%, 7/7 slower; repeats remain +3.44%, 7/7; P1 +4.21%, 6/7;
parsed repeats +4.70%, 6/7. N128 command-v2 V/O Display instead has O1
**+53.32%, 7/7**, original repeats **−2.92%, 2/7 slower**, P1 **+0.66%, 1/7**,
and parsed repeats **−3.13%, 2/7**. The strong phase regression is therefore
strongly dependent on first-call context, while smaller later-call differences
remain mixed. Parsing creates a fresh tree after prior serialization,
comparisons, copying and destruction; it is not a cold-state or identical-
allocation-layout experiment. [Factor object/round results](factors-analysis.json).

## Bounded recommendation

Retain V as the measured implementation recommendation: the native complete
consumer and wider process comparisons improve across all six tested cases,
while exact complete outputs remain equal. Preserve the explicit N128
command-v2 first-Display regression and individual adverse phase pairs in the
final report. Seven observations per cell on a shared host establish the
reported campaign, not a universal latency distribution or equivalence bound.

For a caller able to consume bytes and supply an independently known capacity,
the full direct writer is a useful optional serialization path. Within V's
supplemental sham cells it improves O1 total over V's ordinary Display:

| N / commands | Display → writer-full O1 ms | O1 change; slower pairs | Complete first-consumer change; slower pairs |
| --- | --- | --- | --- |
| 128 / 0 | 0.924537 → 0.647997 | −29.91%; 0/7 | −1.52%; 0/7 |
| 512 / 0 | 2.499720 → 1.331383 | −46.74%; 0/7 | +0.20%; 3/7 |
| 128 / 2 | 1.028773 → 0.736540 | −28.41%; 0/7 | −1.34%; 3/7 |
| 512 / 2 | 2.537813 → 1.385981 | −45.39%; 0/7 | −0.77%; 2/7 |

Those direct Display/writer contrasts were independently recomputed from
[retained factor process rows](factors/samples.jsonl), with setup included.
They support a serialization-window improvement; the complete consumer effect
is smaller and mixed. Full Display versus full writer also consistently
changes write cost, but this compares the whole formatter/adapter and
String-versus-Vec writer paths, not one isolated adapter operation. Retaining
a buffer or discovering its required size can add other caller costs; neither
is free or validated by this fresh-output-capacity experiment.

Do not add preparatory input touch or serialize/parse a second tree as a remedy.
Do not claim presizing fixes the N128 command-v2 V/O phase regression. The
source-local setup finding supplies a narrower target for the separate bounded
PMU diagnostic; routine attribution and exact physical causation remain
unresolved until that diagnostic reproduces the gap and supplies its own
valid evidence.
