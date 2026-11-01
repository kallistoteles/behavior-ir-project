# Core typed record materialization investigation

Guarded reuse of decoded record fields reduced observed median Store commit time
by **6.00–16.55%** against the previous, already improved prototype in this
campaign. At 8,192 existing entities, commit fell from **1,913.41 to 1,596.68 ms**.
Every compared decision remained byte-identical, including the
**4,085,191-byte** decision at that population.

The gains apply to the declared commit/evaluate timers. Some other measurements
regressed: the smallest complete probe process was 1.16% slower, and extra
standalone serialization medians increased at populations 128 and 512. The
retained evidence supports a commit-stage improvement for this fixture, with
consumer workload accounting still needed before adoption.

## Three implementations of the same record contract

The source base is research commit
`1a3ae37623cf90b4608a678ef283ee313306d9bb` plus the
[previous strict-decode reuse patch](prior-decode-reuse.patch). All baseline
timings below are fresh measurements from this campaign. Historical timings are
kept in their original investigation.

| Arm | Internal materialization |
| --- | --- |
| A baseline | The previous prototype: clone JSON for the owned Record08 parse, clone/project its common JSON fields, then clone/parse Record07. |
| B borrowed | Deserialize the same owned Record08 and Record07 types from the existing borrowed JSON value. This removes the preliminary `raw.clone()` calls; result strings and values remain owned. |
| C projected | B plus move already decoded common fields into Record07, convert the common typed trace fields, then run the unchanged common semantic validator. Non-object traces retain the original projection/parser path. |

The [B patch](borrowed.patch), [C patch](projected.patch),
[complete candidate patch](candidate.patch) and source snapshots identify each
arm. The [source audit](source-audit.md) inventories every field and default.
The [correspondence argument](correspondence.md) states the exact reuse premises.
The shared schema block and common semantic-validation body retain their original
definitions; the [source comparison](source-equivalence.json) hashes the unchanged
semantic body.

## A compatibility counterexample determines the fallback

Serde accepts positional arrays as struct representations. CurrentTrace has
thirteen fields; the shared SemanticTrace has ten. An otherwise valid current
record can contain this eleven-element trace:

```text
["precondition", H, {}, true, null, null, [], null, null, null, null]
```

Here H is a valid hash. Typed current parsing accepts the extra optional null.
The old raw projection leaves arrays intact, so shared parsing rejects it with
`invalid length 11, expected fewer elements in array`. Unconditional typed
conversion could discard that positional field and change acceptance or the
selected error.

C therefore chooses the original raw projection and parser whenever a trace
entry is not an object, after completing all existing v0.8 checks. It preserves
accepted short arrays, rejected long arrays, raw-key-dependent null behavior and
the precedence of child-validation failures over later projection failures.
The executable controls retain this counterexample and compound error cases.
No blanket array refusal or replacement Serde diagnostic was introduced.

## Primary measurements

Five fresh processes per arm/population ran sequentially, in the frozen rotated
and reversed order, on CPU 7. Both new arms use the same locked dependencies,
Rust 1.98.1 release settings and unchanged Core031 single-create driver. The
baseline uses its exact matching retained binary, measured afresh. Diagnostic
counters are absent from all six timing executables.

The native fixture uses InMemoryBackend, local positivity and a genuinely affected
global count rule. It creates one entity under the existing complete record
format. Timed cases emit no commands; separate controls exercise commands and
references. The host is the recorded shared x86_64 Xeon X5670 system, with 8 GiB
child address-space limits and a 180-second subprocess limit. OS cache is not
flushed. Builds, tests and lint checks finished before collection.

Commit medians in milliseconds; reductions are ratios of the same campaign's
medians:

| Existing entities | A baseline | B borrowed | C projected | B vs A reduction | C vs A reduction | C vs B reduction |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 128 | 20.69 | 20.28 | 19.45 | 1.98% | 6.00% | 4.11% |
| 512 | 87.67 | 83.69 | 79.74 | 4.54% | 9.05% | 4.73% |
| 2,048 | 413.85 | 399.68 | 366.48 | 3.42% | 11.44% | 8.30% |
| 8,192 | 1,913.41 | 1,706.32 | 1,596.68 | 10.82% | 16.55% | 6.43% |

C's evaluate-plus-commit medians are 6.75%, 7.04%, 10.47% and 12.52% lower than
A's at these populations. At N8192 the combined median falls from 2,398.32 to
2,097.95 ms. Combined time is summed **within each sample before taking its
median**, rather than adding separate phase medians. Setup, artifact writing and
extra standalone serialization are outside those native timers.

Each commit comparison is faster in 19 of its 20 matched pairs. The adverse pairs
remain explicit: B/A at N128 repetition 1 is 2.76% slower; C/A at N128 repetition 2
is 3.05% slower; C/B at that repetition is 5.33% slower. Combined C/B time also has
two adverse pairs, including a 0.26% regression at N8192 repetition 1. These are
observed samples, without a latency-distribution or universal-speedup claim.

The [protocol](protocol.md), [precollection identities](precollection.json),
[build manifest](builds.json), [environment](evidence/environment.json),
[all 60 samples](evidence/samples.jsonl) and [primary assessment](evidence/assessment.json)
retain the full measurement conditions. Percentage gains are not added across
arms or across investigations.

## Other phases retain measured regressions

The unchanged driver separately serializes the completed decision after commit.
That operation supplies the actual decision bytes used for comparison. Its
timing is outside the primary evaluate/commit timers. Launcher process totals
also include setup, output writing, destruction, capture and collector JSON
decoding, and therefore describe a wider workload.

Extra serialization medians in milliseconds, with the wider process comparison:

| Existing entities | Serialize A | Serialize B | Serialize C | C vs A serialization change | C vs A process change |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 128 | 1.110 | 1.095 | 1.203 | +8.30% | +1.16% |
| 512 | 5.427 | 5.380 | 6.006 | +10.69% | −2.19% |
| 2,048 | 11.133 | 10.432 | 10.367 | −6.88% | −3.36% |
| 8,192 | 44.406 | 40.872 | 42.010 | −5.40% | −5.74% |

C/B serialization medians also regress by 9.81%, 11.64% and 2.78% at N128, N512
and N8192. Evaluate has small adverse medians in some comparisons. The source of
these differences was not isolated in this experiment, so they are not dismissed
as noise or attributed to the removed parsing work. All phase medians and every
adverse paired observation are retained in [secondary analysis](secondary-analysis.json).

The result therefore supports the specific commit-stage reduction and its
measured combined window. B is the smaller source change; C adds further commit
savings, an explicit compatibility fallback and schema-correspondence maintenance.
Actual consumer costs should determine which candidate to promote.

## Correctness and evidence checks

All 60 timed decisions matched complete bytes at each population. Nine small
full-path runs formed three identical A/B/C observation triplets, covering the
ordinary workflow, commands with references, and a longer fixed-population update
history. Their records, bundles, commits/results, history, versions, read output,
command page and three replay reports match. The driver also reopens and evaluates
the Store cold. These small cases are correctness controls; their subphase timings
are not additional performance claims.

The campaign retains 69 successful process attempts and 21 lossless gzip
artifacts: four decision triplets and three full-observation triplets. The
[artifact verification](artifact-verification.json) and independent review confirm
complete inventories, hashes, sizes, all medians/ratios and the 23 frozen inputs.
The previous investigation's retained artifacts remain unchanged.

Candidate C validation completed with:

- **568 Core tests passed**, including all eight new materialization controls;
  two opt-in tests remained ignored.
- **88 focused Store tests passed**, covering historical profiles, governance
  context, forged evidence, complete observations, reuse and recovery; one opt-in
  probe remained ignored.
- **21,156 generated comparisons per named run** against the frozen validators:
  18,917 field mutations, 1,767 sequence forms and 472 integer-bound cases, plus
  positive seeds and explicit precedence/counterexample controls. Comparisons
  require equal complete command bags or exact error code/message.
- **Five collector controls passed**, including rejection of an omitted entire
  arm and retention of failures/timeouts. These validate the evidence harness.
- The Core library Clippy check with warnings denied and the targeted runtime/
  control formatting check passed.

The new counter control first fails on A's duplicate common typed decode. B's
seven semantic controls pass; C's reuse goal applies to the combined arm. C passes
all eight, while accepted array-form traces still exercise the original parser.
Existing raw lexical controls retain duplicate-key, noncanonical-number,
malformed-input, Unicode and whitespace coverage.

The initial red attempt used an invalid test precondition shape. That fixture was
corrected before optimization; the corrected log isolates the intended failure.
The later integer and child-error precedence controls were added before C and
executed on B and C. The logs and [reproduction instructions](reproduce.md) retain
this history without treating setup failures as Core defects.

The [validation summary](validation.json), [Core log](core-tests.log),
[Store log](store-tests.log), [focused control log](projected-controls.log) and
[library lint log](core-clippy.log) define the executed scope. Full workspace
adoption gates remain separate. Source correspondence and finite conformance
provide evidence for these implementations, without a machine proof of all Core
or Serde behavior.

## Where the investigation goes next

The current full record remains population-sized: 64,742, 254,822, 1,019,335 and
4,085,191 bytes across the four populations. This work removes repeated internal
materialization while preserving those outputs and their validation contract.

The next useful experiment is a fresh phase profile of the guarded candidate,
including record construction, canonicalization, hashing and the observed extra
serialization regressions. That profile should guide the next optimization and
representative consumer measurements. Compact authenticated evidence and
independent history verification retain their separate correspondence,
completeness and reconstruction obligations.

The scratch checkout is `/tmp/behavior-ir-core-continuation-20261029`, branch
`research/typed-record-materialization-20261031`. This directory preserves the
source snapshots, patches, oracle, controls and results independently of that
scratch build. [Artifact hashes](artifact-sha256.json) bind the retained files.
