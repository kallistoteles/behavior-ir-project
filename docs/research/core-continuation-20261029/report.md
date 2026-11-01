# Core replay decoding investigation

Removing one repeated JSON round trip reduced observed median commit time by
**8.6–10.9%** in the frozen single-create fixture. Every timed decision remained
byte-identical. At 8,192 existing entities, median commit fell from **1,870.27 ms
to 1,705.76 ms**, while the decision remained **4,085,191 bytes**.

This continuation resolves one feasibility question left by Core031/032: some
current-format processing can be removed while preserving the tested semantic
outputs. It supplies an experimental patch, a source correspondence argument,
regression controls and retained measurements. The patch is in an isolated Core
checkout; production adoption requires the normal feature and workspace gates.

## The repeated operation

At Core revision `1a3ae37623cf90b4608a678ef283ee313306d9bb`,
[`reproduce_record`](https://github.com/kallistoteles/behavior-ir-core/blob/1a3ae37623cf90b4608a678ef283ee313306d9bb/crates/behavior-core/src/record.rs#L424)
strictly decodes incoming text, then calls `replay_profile` with the resulting
immutable JSON value. The current-record branch serializes that value and calls
`DecisionRecord::from_json`, which strictly decodes it again before running
`validate_record08`.

The [candidate patch](candidate.patch) calls `validate_record08(stored)` directly.
It retains the initial lexical check, complete typed validators, module/profile
checks and exact reproduction. There is no new cache or change of trust boundary.
The [correspondence argument](correspondence.md) explains why the second round
trip is redundant for this caller and identifies the trusted serializer/decoder
implementation assumptions. The unchanged public record decoder remains strict.

The source audit also identified wrapper snapshot/history capture and typed-record
cloning as separate costs. This experiment holds those paths constant; their
remaining questions are recorded in the [independent source audit](independent-source-audit.md).

## Measured results

Both arms use the same Core revision, locked dependencies, Rust 1.98.1 release
build and unchanged Core031 single-create driver. Each point has five fresh
processes per arm, interleaved by repetition on CPU 7. The fixture uses
InMemoryBackend, local positivity, a genuine affected global count rule and the
complete current record format. Timed cases have no command emissions; command
behavior is covered by the separate controls below.

| Existing entities | Decision bytes in both arms | Baseline commit median ms | Candidate commit median ms | Commit reduction | Evaluate plus commit reduction |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 128 | 64,742 | 23.12 | 20.61 | 10.85% | 8.60% |
| 512 | 254,822 | 97.48 | 88.08 | 9.64% | 8.38% |
| 2,048 | 1,019,335 | 436.36 | 398.68 | 8.64% | 7.03% |
| 8,192 | 4,085,191 | 1,870.27 | 1,705.76 | 8.80% | 6.92% |

Evaluate plus commit is summed **within each sample**, then its median is taken.
At N8192 that median falls from 2,325.30 to 2,164.32 ms. Separate evaluate medians
are 455.04 and 455.38 ms. Setup, artifact writing and the extra standalone record
serialization are outside these native phase timers. Launcher totals include
additional process/capture work and are retained separately.

Commit is faster in 19 of the 20 matched sample pairs. The remaining N8192 pair
regresses slightly, from 1,698.14 to 1,705.35 ms. Five samples on a shared host
support these observed medians, without establishing latency distributions or a
gain for every request. This experiment does not attribute a measured percentage
of total CPU time or allocations to the parser. Its deterministic control
establishes that the repeated constructor call is removed.

The host is Linux 6.18.55 on an Intel Xeon X5670, with 8 GiB child address-space
limits and a 180-second subprocess limit. OS cache was not flushed. No build or
test ran concurrently with the timing campaign. Historical Core031 measurements
retain their original environment and are separate observations.

The [frozen protocol](protocol.md), [precollection hashes](precollection.json),
[build identities](builds.json), [environment](evidence/environment.json),
[all samples](evidence/samples.jsonl) and [assessment](evidence/assessment.json)
provide the exact conditions and results.

## Output and regression evidence

All 40 timed samples completed and matched complete decision bytes at each
population. Fourteen retained gzip artifacts contain four decision pairs and
three complete observation pairs. Their decompressed hashes and sizes verify;
the N8192 first decision also matches the earlier frozen Core031 artifact exactly.
See [artifact verification](artifact-verification.json).

The additional full-path cases use N=8:

| Case | Prefix history | Changes exercised |
| --- | ---: | --- |
| Ordinary | 0 | Two creations and complete ordinary observations |
| Commands and references | 2 | Two duplicate command emissions per event, references and filtered count |
| History and update | 8 | Fixed live population, updates and duplicate command occurrences |

Each baseline/candidate pair has identical records, bundles, committed events and
results, history/head, versions, read output, command page and all three replay
reports. The existing driver also reopens the Store and performs a cold
evaluation. These pairs are correctness controls; their process timings are not
additional speedup claims. Separate Store tests exercise lost acknowledgement
and recovery.

Validation on the candidate completed with:

- **560 Core tests passed**, including the five new replay controls; two opt-in
  tests remained ignored.
- **88 focused Store tests passed** across seven targets covering archived
  profiles, governance context, forged evidence, complete observations, reuse
  and commit/recovery faults; one opt-in probe remained ignored.
- **Four collector controls passed**, checking changed output, incomplete or
  duplicate inventory, failed processes, malformed measurement JSON and retained
  timeout output. These test the harness, rather than proving Core semantics.
- The changed runtime source passes its formatting check.

The [new controls](replay_materialization.rs) cover duplicate/escaped duplicate
keys, noncanonical numbers, malformed text, Unicode/whitespace acceptance, closed
record errors and module/profile error precedence. The diagnostic control fails
on the baseline's extra `from_json` call and passes on the candidate. It does not
count ingress strict decoding, so lexical controls remain necessary.

The first red run contained an incorrect expected error prefix in a new test.
That assertion was corrected before implementation; the corrected red run
isolates the intended redundant-parse failure. Both logs are retained, along with
the four baseline semantic controls passing. No Core failure is inferred from
the initial test assertion mistake.

The [validation summary](validation.json), [Core log](core-tests.log),
[Store log](store-tests.log) and [reproduction instructions](reproduce.md)
record the executed scope. Full workspace release gates were not part of this
research comparison.

## Consequence for the investigation

This is a useful small improvement within the existing full-evidence contract.
It removes repeated processing without shrinking the requested output. The
four-million-byte record and the remaining typed validation, reproduction,
materialization and hashing costs remain visible.

The next same-format experiment should isolate owned typed-record decoding and
the v0.8-to-v0.7 common-field projection. It needs its own error-correspondence
audit and measurements; this result supplies no measured saving for that work.
Wrapper snapshot/lifetime reuse additionally needs the stability and lineage
premises identified in the source audit. Compact independent verification still
requires explicit authenticated completeness and reconstruction contracts.

The scratch checkout is `/tmp/behavior-ir-core-continuation-20261029`, branch
`research/replay-materialization-20261030`. This directory retains the patch,
controls, driver, protocol and results so the investigation survives removal of
the scratch build. [Artifact hashes](artifact-sha256.json) bind the retained files.
