# Archived bundle ownership experiment

Prepared 2026-10-31 before implementation or measurement. Continue from guarded
typed-record candidate C (`record.rs` SHA-256
`09adc58bde0088de5144785c24f734ff24e8cd4d67b85f7178f0d8b5079b692a`).
Keep all earlier studies and scratch checkouts unchanged. Use a fresh Core clone
at `1a3ae37623cf90b4608a678ef283ee313306d9bb` plus that C snapshot.

## Question and bounded change

Does transferring the already-owned archived bundle into the final transition
record remove a complete bundle clone while preserving every observation?
`commit_impl` currently clones incoming bundle to `archived_bundle`, optionally
archives authenticated v2 context, then clones it into `TransitionRecord.bundle`
and never uses the local bundle again. Compute its existing fallible hash at
the event-construction stage and move the owned bundle into that event.

Retain the incoming-to-archive clone, all canonical/semantic/error checks, hashes,
recovery logic and independent backend verification/CAS. This is a scratch
research prototype, without production adoption or workspace-gate claims.

## Constitution and correspondence obligations

Use the existing public Store evaluate/commit/backend/history boundaries and
diagnostic Work counters. Observe a failing ownership-work goal before changing
the runtime code. Two diagnostic-only source-site counters distinguish archive
and event clones; they measure those sites, not allocator totals. The unchanged
runtime reference is the oracle for complete records, bundles, hashes, history,
versions, commands, reads, replay and errors. The clone is of owned pure data;
moving it must preserve the exact product seen by hashing and the backend.
Document fallible-check order explicitly, including v2 context archiving and
hash errors. No new primitive, dependency or serialized field is justified.

## Validation before measurement

Add controls for legacy and v2 fresh commits, unchanged caller bundle, archived
bundle equality/hash, exact retry and altered-bundle refusal without mutation.
The resource goal expects one incoming archive clone and zero final event clones;
observe both goals fail on the baseline with the counters installed. Existing
Store tests must cover trusted context/evidence, forged observations, historical
profiles, backend atomic products and CAS/recovery. Run full Store tests and
targeted lint/format controls; document exact scope and pre-existing failures.

Build normal release baseline and moved executables with identical shared
drivers, no validation-work. Keep diagnostic counters out of timing binaries.
Freeze source/patch/test/collector/binary/lock identities before collection.

## Collection

Use the unchanged single-create phase driver at N128,512,2048,8192, two arms
(baseline guarded C and moved), seven fresh-process repetitions: 56 timed
processes. Alternate arm order by repetition and population. Measure evaluate,
commit, extra ready-record serialization, their within-sample sums, and wider
process time separately. Retain all samples and adverse observations.

Run three existing full-path cases in both arms: ordinary, v2 commands/references,
and v2 history/update; six correctness processes. These small-case timings are
not performance claims. Total declared attempts: 62. Compare every timed record
with the prior frozen expected bytes and each complete full observation across
arms. Retain eight representative decisions and six full observations as gzip.

Run measured children alone on CPU7 with 8GiB address-space limit and 180-second
timeout, after all builds/checks finish. Do not flush OS cache. Retain attempted
command/status/stdout/stderr, including handled failures/timeouts/interrupts.
Incomplete evidence cannot be Complete. Run collector rejection controls before
freezing it. Report medians and paired changes from this campaign; do not combine
historical timing ratios or subtract earlier diagnostic spans as predicted gain.
Preserve existing serialization regressions as separate prior observations;
measure the candidate's secondary phases rather than presuming improvement.
