# Reusing strict record decoding within one Core replay call

Frozen before candidate measurements on 2026-10-29. Source baseline:
`1a3ae37623cf90b4608a678ef283ee313306d9bb` in behavior-ir-core.

## Question and hypothesis

Does eliminating the serialize and strict-decode round trip inside
`record::replay_profile` improve complete Store commit time while retaining exact
records, transitions, replay outcomes and selected validation errors?

The candidate calls the existing `validate_record08(stored)` directly. Its sole
caller, `reproduce_record`, has just obtained `stored` from `decode_strict` and
does not mutate it before selecting the profile. The candidate retains the
ingress lexical check and every existing typed record validation. It introduces
no cross-call cache, independently supplied checked token or new authority.

This compares one repeated representation step. It does not change Core's full
record format, snapshot wrapper, validators, backend checks or replay policy.

## Controls before timing

1. Observe a failing diagnostic control on the baseline: replay currently calls
   `DecisionRecord::from_json` again after strict decoding.
2. Preserve exact closed-document errors on unknown fields, wrong profile,
   explicit null, missing complete universe, altered command payload and refused
   partial effects. Compare with the unchanged public record decoder.
3. Preserve ingress refusal for duplicate and escaped duplicate keys, floats,
   exponents, negative zero, out-of-range integers and truncated text.
4. Run existing Core record, command, historical replay and evidence-authority
   tests. Run Store full-observation, profile and authority controls appropriate
   to this seam. Tests provide finite conformance, not a general implementation proof.

## Measurement profile

- Separate release binaries for baseline and candidate, both built from the same
  source revision and locked environment. No diagnostic instrumentation in timings.
- Reuse the existing Core031 single-create fixture: local positivity, affected
  global count, one actual create/evaluate/commit, immutable input timestamps.
- Initial live populations 128, 512, 2048 and 8192; five fresh-process samples per
  arm per population. Alternate arm order by repetition and retain every sample.
- Pin each measured process to CPU 7. One measured process at a time, no concurrent
  build. Address-space limit 8 GiB, 180 seconds per process. Record the actual host
  and affinity; OS cache is not flushed.
- Record evaluate and commit separately, and sum them within each sample before
  taking the cycle median. Setup, artifact serialization and output writing are
  outside those timings. Do not add phase medians.
- Compare complete decision bytes for each timed pair and repeated sample. Retain
  an actual representative decision per arm/population with hashes.
  Output identity comparisons happen outside the timed sections.
- Launcher `process_ms` includes subprocess launch/capture and JSON decoding in
  the collector; it is distinct from the native evaluate and commit timers.
- Three additional N=8 full-path case pairs vary history, command multiplicity and
  references, comparing and retaining all observation families and replay results.
- Report observed gains or regressions without a preselected speedup threshold.
  This is an exploratory feasibility experiment, not release acceptance or a
  production latency guarantee. A mismatch, failed required control or incomplete
  sample remains explicit and blocks any favorable equivalence conclusion.

## Preservation

The protocol was prepared on October 29; execution resumed October 30 after the
pinned environment became available. Precollection review added binary-mode and
row-identity guards plus retained subprocess-failure reports. No timing sample
had been collected before these guards were added.

The scratch Core checkout is `/tmp/behavior-ir-core-continuation-20261029`.
Research artifacts and a reproducible source patch are retained in this directory
of behavior-ir-project. Original Core worktrees and published artifacts are preserved.
