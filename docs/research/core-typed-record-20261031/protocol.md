# Typed record reuse experiment

Prepared on 2026-10-31 before implementation or timing. This continues the
same-format investigation from `../core-continuation-20261029/report.md`.

## Claims and arms

The source revision is Core `1a3ae37623cf90b4608a678ef283ee313306d9bb` plus the
previous experiment's strict-decode reuse patch. That exact source and its
retained binaries form arm A. Its old timings are not reused.

- **baseline A:** existing owned JSON clones, raw v0.8-to-v0.7 projection and typed
  reparsing, with the prior strict-decode improvement already applied.
- **borrowed B:** deserialize the same owned Record08 and Record07 types from
  `&Json`, avoiding the temporary complete clone passed to `from_value`.
- **projected C:** B plus move the already decoded common Record08 fields and
  convert the typed traces into Record07 before executing its existing semantic
  validator. Preserve the exact original projection and parser after all v0.8
  checks whenever a raw trace entry is not an object.

The fallback is mandatory: Serde supports struct sequences, and CurrentTrace
accepts eleven-element arrays that SemanticTrace rejects. Typed conversion must
not erase that rejection or reorder its error relative to v0.8 checks.

## Correctness controls

Before changing runtime materialization, freeze the original validators as a
test-only oracle. Compare the complete command bag or exact RecordError code and
message through the public strict constructor, across current and archived
seeds, field replacements/deletions/unknown fields, sequence forms and compound
errors. Keep shared nested struct types unchanged so comparisons isolate this
materialization change. Frozen validators and retained seeds are hashed.

A test-only counter establishes the optimization goal: a current object-form
record no longer deserializes Record07. Observe this test fail on A; B remains
an intermediate arm that does not fulfill C's goal. Verify array-form fallback
still runs the original Record07 parser. Counter hooks exist only in libtest
builds and do not enter timing binaries.

Run B's semantic differential controls, then C's complete Core tests and focused
Store profile, authority, forged-evidence, reuse and recovery tests. Preserve
strict lexical ingress controls from the earlier experiment. Treat mismatched
acceptance, command bags or selected errors as blockers. These source arguments
and finite controls do not constitute a machine proof of Serde or Core.

## Timing and output comparison

Reuse the unchanged Core031 single-create driver and full-path example. All
arms use the same locks and release settings, without validation-work counters.
Bind actual source patches and binaries before collection.

- Populations 128, 512, 2048 and 8192; five fresh-process repetitions per arm,
  for 60 timed samples. Within each repetition rotate A/B/C by `r % 3`, reversing
  the rotated order when `r >= 3`. Retain every attempted process and failure.
- One measured process at a time, CPU 7, 8 GiB address-space limit and 180-second
  timeout. Finish builds/tests before measurement. OS cache is not flushed.
- Evaluate and commit are separate native timers. Sum them per sample before
  taking the combined median. Setup, artifact writing and extra standalone
  serialization are outside those timers. Launcher totals have a wider scope.
- Compare full decision bytes for every sample and preserve one actual decision
  per arm/population. Repeat the previous three N8 full-observation cases under
  all three arms, retaining commands, history, versions and all replay reports.
  These small cases are correctness controls, not extra performance claims.
- Report same-session observed medians and all regressions. No favorable
  speedup threshold is selected. B/A, C/B and C/A effects must be computed from
  this campaign; do not add percentage gains or old phase medians.

The initial source audit and constitution check require exact execution/error
equivalence, immutable original evidence, no second semantics, deterministic
ordering and test-first controls. This is an isolated research prototype with
unchanged public APIs and dependencies; production adoption remains subject to
the owning repository's normal feature process and complete workspace gates.
