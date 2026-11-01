# Core archived bundle ownership experiment

2026-10-31. Moving the owned archived bundle into its final event removes one
complete temporary bundle clone on fresh action commits. Observed commit medians improve
**4.75% at N128, 4.43% at N512, 0.13% at N2048 and 1.49% at N8192** against the
guarded typed-record candidate C, measured afresh in this campaign. The large
population results are modest, and some matched pairs regress.

All 62 processes completed successfully and every compared output matched
complete bytes. The Store library/integration gate passed **671 tests**, with
24 opt-in tests ignored and none failed. This is an isolated research prototype;
it does not claim production adoption, full workspace gates or a universal
speedup.

## The change and its correspondence

The [runtime patch](candidate.patch) makes three logical edits in
`Store::commit_impl`: compute the existing `archived_bundle.hash()?` at the final
assembly stage, move `archived_bundle` into `TransitionRecord.bundle`, and use
the computed hash in that record. It introduces no public signature, dependency
or serialized field. [Source audit](source-audit.md) traces the ownership and
error boundaries against the primary code.

The incoming bundle is still borrowed. Its initial owned archive clone remains,
including the v2 mutation that archives independently supplied authenticated
context. The final event owns the same fully populated archive that previously
was cloned into it. There is no later local use requiring another owner. The
hash still applies to the enriched archive, rather than the original incoming
bundle. All record hashes, semantic checks, incremental-child validation,
backend verification, CAS and backend storage copies remain.

The local hash moves before the struct literal's initial infallible field
construction/clones. It stays after the same integrity/state computations and
before every later fallible operation. This preserves returned typed-error
precedence; it intentionally changes allocation/destruction behavior. The
correspondence does not claim identical timing, OOM behavior or allocation panics.
The two exact error controls retain a late legacy-context hash refusal and an
earlier timestamp refusal that must take precedence.

Two diagnostic-only Work fields count the existing archive and event clone
sites. Before optimization, both legacy/v2 ownership goals fail with one event
clone; afterward they observe one archive clone and zero event clones. These
are source-site work counters, not an allocator census or a count of every
deep copy in the Store. They do not enter timing builds or normative records.
The [baseline diagnostic patch](baseline-diagnostic.patch),
[counted Work source](counted-work.rs), counted arm snapshots and
[ownership controls](bundle_ownership.rs) keep that distinction reviewable.

The earlier residual profile attributed 44.795 ms (3.05% of one N8192 diagnostic
commit) to the event clone, separately from the initial archive clone's 92.569 ms.
That illustrative elapsed scope motivated this experiment; it did not predict
an uninstrumented gain or measure all resulting destruction costs. The new
measurements below stand on their own.

## Same-campaign measurements

The [protocol](protocol.md) was prepared before implementation. Both normal
release arms were built in the same fresh checkout with the same pinned
dependencies, compiler and drivers, without `validation-work`. Baseline is
guarded C; moved is C plus ownership transfer. This campaign rebuilds and
remeasures baseline C, rather than comparing against earlier wall times.

The unchanged single-create fixture uses InMemoryBackend, a local rule and an
affected global count rule. Four populations × two arms × seven fresh-process
repetitions yield **56 timed samples**. Arm order alternates by population and
repetition. Children run one at a time on CPU7, with 8GiB address-space and
180-second limits, after all builds/tests finish. OS caches were not flushed.
The shared x86_64 host and seven observations per cell do not establish a
latency distribution or statistical certainty.

Commit medians in milliseconds; change is `100 × (moved / baseline − 1)`:

| Existing entities | Baseline C ms | Moved ms | Change | Slower moved pairs / 7 |
| ---: | ---: | ---: | ---: | ---: |
| 128 | 19.625 | 18.692 | −4.75% | 0 |
| 512 | 80.481 | 76.912 | −4.43% | 1 |
| 2,048 | 379.484 | 378.976 | −0.13% | 4 |
| 8,192 | 1,571.540 | 1,548.154 | −1.49% | 2 |

The commit resource reduction is concrete, while N2048 provides little evidence
of a meaningful elapsed improvement: its median difference is only 0.508 ms,
and four matched pairs are slower. At N8192 the median difference is 23.386 ms.
Adverse commit pairs remain explicit: N512 repetition 0 is 4.31% slower;
N2048 repetitions 2/3/4/6 are 0.26%/0.23%/0.15%/0.01% slower; N8192 repetitions
4/5 are 3.26%/0.08% slower. Repetitions are zero-based. All exact ratios are
retained in [analysis.json](analysis.json).

## Secondary work and serialization

These changes use medians from the same seven processes per arm. Combined
windows are summed **within each sample before taking a median**. The wider
process timer also includes setup, destruction, writing/capture and collector
JSON decoding, so it is a different workload from native evaluate/commit.

| N | Evaluate change | Evaluate + commit change | First extra serialization: baseline → moved ms | Serialization change | Evaluate + commit + serialization change | Process change |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 128 | −1.07% | −4.08% | 1.253 → 1.041 | −16.95% | −4.68% | −2.23% |
| 512 | −0.56% | −3.72% | 6.250 → 4.242 | −32.14% | −5.24% | −1.64% |
| 2,048 | +0.05% | −0.09% | 10.570 → 9.755 | −7.71% | −0.25% | +0.0064% |
| 8,192 | +0.04% | −1.97% | 40.806 → 39.236 | −3.85% | −2.08% | −0.65% |

All four serialization medians improve against this campaign's baseline C.
N8192 nevertheless has two slower serialization pairs, including +10.93% at
repetition 4. Wider process has 1/2/4/3 adverse pairs at N128/512/2048/8192.
The N2048 process median is very slightly higher (0.087 ms), without a resolved
process improvement at that population. Evaluate, combined windows and every
individual pair remain available in the analysis; improved medians do not mean
all samples improve.

The timed operation remains `evaluated.record.to_string()` immediately after
commit in the original shared driver. The optimization changes temporary
ownership during commit; it does not replace the Value serializer. These data
do not establish an allocator, cache or compiler mechanism. They also do not
show that the earlier C-versus-A first-serialization regression is resolved:
**A is not measured here**, and this campaign does not repeat the prior
original/repeated/fresh-parsed experiment. Its context-sensitive findings and
all earlier adverse observations remain preserved in the
[previous report](../core-residual-profile-20261031/report.md). Ratios from the
different campaigns must not be added or compared as cumulative speedups.

## Exact outputs and controls

All 56 timed decisions equal the earlier frozen expected bytes at their
population: **64,742 / 254,822 / 1,019,335 / 4,085,191 bytes**. This removes an
internal copy while preserving population-sized public output.

Six additional processes form three complete baseline/moved observation pairs:
ordinary workflow, v2 commands with references, and v2 history/update. Full
records, bundles, committed results/history, versions, reads, commands and all
three replay reports match byte for byte. The driver also reopens the Store
and evaluates cold. These small full-path runs are correctness controls; their
timings are not additional performance claims.

The completed validation comprises:

- **671 Store library/integration tests passed, 24 opt-in tests ignored, zero
  failed**, using `--features validation-work --lib --tests`. This includes the
  three new ownership/event controls and two exact hash-error controls, trusted
  context insertion/mismatch/recovery, forged observations, backend atomic
  argument-product failures, historical profiles, lifecycle/migration histories
  and replay/tampering cases.
- Baseline red: one semantic event control passed and both resource goals failed
  at the intended extra event clone. The two later exact hash/error-order controls
  also passed on baseline before the runtime change. Candidate controls retain
  unchanged caller bytes, archived bytes/hash, exact retry and refusal without
  publication. [Validation summary](validation.json) and logs retain exact counts.
- Targeted Store library/new-test Clippy passed with warnings denied, and the
  changed-source formatting check passed. Eight collector controls passed for
  complete matrices, missing/duplicate samples, omitted arms, changed bytes,
  diagnostic timing modes and output retention on nonzero exits, handled
  timeouts and interrupts.

An initial broad source-count assertion stopped patch preparation before any
runtime source write. A separately launched still-baseline Store test command
then failed during compilation because the normal-only research timing example
references profiler APIs under `validation-work`, while this experiment installs
only counters. No tests ran in that command. The corrected `--lib --tests`
invocation excludes that example and passed. Both attempts/corrections are
retained in [preflight notes](preflight-notes.json) and `baseline-store-tests.log`.
No dummy profiler APIs or runtime changes were added to mask the combination.

These research checks are not the owning repository's complete workspace,
external-consumer, determinism and release gate set. Source correspondence and
finite conformance support this bounded ownership change, without proving all
possible Store/backend behavior.

## Evidence and next target

[Precollection identities](precollection.json) freeze 33 inputs before the first
attempt. [Build/source identities](builds.json), [environment](evidence/environment.json),
[all attempts](evidence/attempts.jsonl), [timed samples](evidence/samples.jsonl),
[full samples](evidence/full-samples.jsonl) and [assessment](evidence/assessment.json)
retain 62 successes and 14 lossless gzip artifacts. The collector compares every
raw output before removing temporary files. Handled failures/timeouts/interrupts
retain available stdout/stderr and status and cannot produce Complete; abrupt
SIGKILL/power-loss retention is not promised.

[Verification](artifact-verification.json) checks frozen hashes, four actual
binaries, live candidate source/locks, exact ordered matrices and attempt
arguments/stdout, all gzip sizes/hashes/bytes, recomputed statistics and the
unchanged manifests of all three prior studies. A background audit independently
recomputed these checks without importing the analysis/verifier. It found no
necessary evidence fixes. [Reproduction](reproduce.md) and the
[self-excluding file manifest](artifact-sha256.json) preserve the complete study.

The scratch candidate is `/tmp/behavior-ir-core-bundle-20261031`, branch
`research/bundle-ownership-20261031`. Earlier scratch sources and records remain
unchanged. The result supports retaining a small ownership simplification as a
candidate, with modest workload-dependent measured benefit. The larger remaining
target is still document/canonical materialization and hashing at real validation
boundaries. Any reuse there needs its own source argument and controls; independent
backend checking must remain intact. The first-serialization mechanism remains
an open investigation.
