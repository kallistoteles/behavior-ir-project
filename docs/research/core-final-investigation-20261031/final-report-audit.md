# Final report audit

2026-11-01. Independent read-only review of the final report against retained
process rows, source, test/control logs and PMU evidence. Recomputed selected
statistics directly from raw rows on CPU6, without running collectors or
analyzers. No tests, builds, experiments or new measurements were performed.
Only this new audit note was written.

**No remaining numerical correction or campaign-rejection issue was found in
the revised report.** The cumulative recommendation is supported for its
stated fixtures and host, and its adverse phase observations remain visible.
Final artifact-manifest verification is still the next integrity step.

## Corrections applied during this review

- The original generic-serialization paragraph incorrectly listed NaN-to-null
  conversion as something direct serde_json writing would change. The pinned
  Value serializer and direct JSON writer both preserve that behavior. The
  revised paragraph states this correctly; duplicate-key reduction, integer
  range errors and custom error precedence remain valid reasons to retain
  generic materialization.
  [Revised paragraph](report.md:43),
  [Value numeric conversion](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/value/ser.rs:150),
  [direct numeric writing](/home/kalle/.cargo/registry/src/index.crates.io-1949cf8c6b5b557f/serde_json-1.0.151/src/ser.rs:154)
- The broad statement that tests preceded runtime changes was narrowed to the
  resource-goal red controls preceding their corresponding runtime changes.
  This matches the retained red logs without implying that every later
  supplementary control already existed at first implementation.
  [Revised chronology](report.md:184), [Core red](hash-red.log),
  [Store red](document-red.log)
- The report now points to the new complete reproduction entry while retaining
  the original frozen recipe unchanged. The capacity recommendation also now
  requires a sufficient existing bound for no-growth behavior, acknowledges
  undersized hints, and charges discovery/retention costs.
  [Complete reproduction](final-reproduction.md),
  [consumer recommendation](report.md:225)

## Numbers independently reconciled

All six original/final commit medians and rounded percentages in the table
match raw native rows. The headline commit reduction range is 25.11–38.37%,
consumer reduction 22.06–30.82% and wider process reduction 10.48–16.44%.
All **42** final/original matched pairs improve for each of those three
metrics. Consumer sums were recomputed within each process before medians.
The view/stream incremental commit range, 11.18–22.29%, also matches.
[Native rows](native/samples.jsonl), [report table](report.md:72)

The adverse details are correct: legacy N128 evaluation is +1.265378%; its
first Display has one slower pair despite the improved median. N128 command-v2
first Display is +25.665313%, all seven pairs slower. Streaming/moved N512
legacy commit is +0.067476%, streaming/moved N128 process +0.358557%, and
moved/typed N8192 commit +0.909613%. Their report rounding and interpretation
are appropriate.

Historical typed/decode first-Display medians recompute to +12.006936% and
+5.839865%, with final/decode −14.405736% and −56.042594%. Initial N512 sink
typed/decode totals are +10.345164%, +12.186081%, +14.237268% and −0.171339%
for Display, vec, writer128 and writer-full, respectively. These match the
report without pooling the distinct benchmark prefixes.
[Anchor rows](anchors/samples.jsonl), [initial sink rows](sinks/samples.jsonl)

The charged input-touch contrast has **40 cells**, all median ratios adverse,
range +11.528362–40.611919%, with **278/280** slower matched pairs. Final
writer-full versus its own sham Display recomputes to −29.911188%, −46.738715%,
−28.405975% and −45.386796% across the four follow-up cases, with no slower
O1 pairs. The report correctly keeps the smaller/mixed complete-consumer
contrast separate.
[Factor rows](factors/samples.jsonl),
[independent serialization interpretation](serialization-conclusion-audit.md)

Attempt receipts independently total **1,215 Completed/exit-zero measured
processes**: native/full 270, initial sinks 224, historical anchors 56,
supplemental factors 560 and PMU 105. The report's 550 primary subtotal and
210 primary/factor representative gzip subtotal agree with verification
inventories. Six reference generations, two intentional failures and three
PMU calibration processes are correctly outside the measured total.
[Primary verification](primary-verification.json),
[factor verification](factors-verification.json),
[PMU verification](pmu-verification.json)

## PMU interpretation

The report matches the independent raw/ELF audit: **133 samples**, including
**132 user-tagged IPs** resolving to exact mapped libc symbol ranges and **one
unexpected kernel-tagged unknown IP**. The two older N512 cells have 118
samples: 117 consolidation/unlink samples and one _int_malloc sample. N128
command-v2 final has 13 consolidation/unlink samples plus the unknown. All
period weights remain in the denominators. The **13 zero-sample processes**
and their exit-zero report commands' retained stderr diagnostics are explicit.
No raw loss/throttle records were found. The wall/instruction medians and both
stat/sampling gap conditions match the independently recomputed results.
[Independent PMU audit](pmu-evidence-audit.md), [PMU discussion](report.md:147)

The linked allocator source/patch note supports explaining what the sampled
consolidation/unlink routines do. The report appropriately distinguishes that
bounded mechanism from exclusive wall-time causation, exact prior chunk
genealogy, cache/TLB/DRAM causes and the smaller historical typed/decode sink
percentage. One optional wording improvement is to use “removing earlier
temporary trees **can** change the work charged to a later allocation”:
the experiment did not trace each particular prior object into the final
allocator lists. This is an interpretation precision suggestion, not a
contradiction in the reported routine attribution.
[Exact allocator-source scope](allocator-source-conclusion.md),
[current mechanism wording](report.md:153)

## Source, validation and recommendation scope

The source/ownership claims match the audited implementation: guarded record
movement retains fallback behavior; the final owned archive is moved; Core
retains complete canonical checking and root-only metadata exclusion; private
Store views borrow the specified JSON leaves while other fields keep their
conversion order; generic and migration paths remain; public facade and
independent checking boundaries are unchanged. The new v2 same-owner factory
remains explicitly unadopted, with no claimed performance gain.
[Source correspondence](hash-source-audit.md),
[patch provenance](freeze-review.md), [unadopted reuse](local-reuse-decision.md)

The resource goals' 65,566→0, legacy 1→0 and v2 2/3→0 counts agree with the
retained red/green controls. They count named old string/materialization sites,
not every allocation or complete hashing cost. The report explicitly preserves
that limitation and the shared-Core aspect of the frozen Store reference.
The recorded seven Core controls, ten Store controls/176 comparisons and
two serialization-probe controls agree with their logs. Gate counts and
ignored-test qualifications agree with validation.json; this review did not
rerun them.
[Red/green controls](view-controls.log), [gate summary](validation.json)

The new executable archive was also read without extraction: all 26 unique
payload members match their SHA-addressed names, and its manifest supplies
45 logical path entries. This preserves executable bytes without claiming
that path/toolchain changes reproduce timing, or that external Nix runtime
dependencies are inside the archive.
[Executable retention](executable-preservation.json),
[archive](executables.tar.gz), [reproduction limits](final-reproduction.md)

The report's recommendation remains appropriately bounded: retain the
compatible cumulative patch for the measured complete workload, preserve the
small-v2 phase regression, reject charged preparatory touch, and offer byte
writing only to consumers whose output contract and capacity policy fit it.
Manual schema/view synchronization, retained generic semantics, independent
validation work and unadopted reuse are classified as maintenance or scope
limits; no global optimality or universal latency claim is supported or made.
