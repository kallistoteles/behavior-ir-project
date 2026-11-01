# Independent freeze and patch provenance review

2026-11-01. Read-only review after the primary native campaign began. No tests,
builds or benchmarks were run, and no frozen input, runtime source or binary was
modified. Independent file hashing and in-memory patch reconstruction ran on
CPU6, separate from the declared CPU7 benchmark children. This new note is a
post-freeze review artifact and does not amend the frozen collector audit.

**No defect requiring interruption of collection was found.** The freeze,
source archives, patch and inspected build receipts correspond to the declared
candidate. This verifies input/provenance consistency, not the outcome of the
still-running campaign or a performance benefit.

## Independently checked identities

Recomputed SHA-256 identities matched all **87 frozen inputs, 41 binary paths,
12 live expected-record files and 349 live final source files**. The binary
inventory is 19 named executable paths, 18 equal-length native/serial/full
aliases and four historical-anchor aliases; it is not 41 independent builds.
The twelve records comprise six complete decision/event pairs. Required
collectors, runner, analyzer, verifier, controls, source/build manifests,
archives, patch, oracle artifacts/receipts and gate records are present in the
freeze. The four earlier manifest identities are pinned indirectly through
frozen `prior-preservation.json`; their actual manifests and all **240** listed
files independently matched those retained identities.
[Freeze](measurement-precollection.json),
[prior identity record](prior-preservation.json)

Both archives have exact, unique, regular-file inventories matching their
manifests: **349 members for the final view source and 103 for the streaming
source**, with every member hash matching. The final archive's whole-file hash
also matches `view-builds.json`; both whole archive hashes match precollection.
The source archives cover the declared crate/source/tool selections, rather
than claiming to archive the whole repository. The base commit supplies
unchanged repository files. Current Core working-tree changes are confined to
the expected crate paths.
[Final build identities](view-builds.json),
[stream identities](stream-builds.json),
[final source archive](view-source.tar.gz),
[stream source archive](stream-source.tar.gz)

## Patch correspondence

Independently parsed every unified-diff hunk and applied it **in memory** to
files read with `git show` at declared base
`1a3ae37623cf90b4608a678ef283ee313306d9bb`. Every preimage/context line and hunk
count matched. All **18 resulting files—nine modified and nine new—exactly
match the final source manifest**. The patch includes the cumulative runtime
changes and validation support. The three newly introduced research examples
are intentionally outside the patch and are separately frozen, archived and
described in the reproduction instructions; the fourth built example already
exists in the base.
[Cumulative patch](solution.patch),
[patch construction](freeze.py:35),
[reproduction scope](reproduce.md)

The first applicability attempt targeted the notes/archive repository, where
the Core crate files do not exist. The retained failure record correctly
classifies it as premeasurement, without runtime edits or a completed freeze.
The corrected check targets `/tmp/behavior-ir-core-patch-check-20261101`; that
worktree was independently observed clean at the exact declared base. The
freeze script records `git apply --check` against that worktree. The independent
in-memory reconstruction above establishes correspondence without relying only
on that retained check's successful return.
[Failed first attempt](freeze-attempt1.json),
[corrected check](freeze.py:46)

## Build and preflight receipts

The final build log records actual compilation of Core, Verify, Store and
the four normal release examples from the isolated final checkout/target,
including explicit rustc commands. The final manifest records no
`validation-work`, no RUSTFLAGS, disabled incremental compilation, the pinned
compiler/Cargo versions and `CARGO_BUILD_JOBS=3`. This is materially stronger
source binding than the rejected shared-target “fresh” preflight, which remains
preserved with its stale moved-reference hashes and remedy. All inspected final
executables match both their build manifest and the frozen alias identities.
[Actual final build](view-build.log:51),
[final manifest](view-builds.json),
[rejected cache preflight](cache-preflight.json),
[isolated clean state](isolated-prebuild.json)

`preflight-verification.json` reports Passed with the same 87-input/41-binary
counts and the independently confirmed four prior manifest identities. The
separate oracle receipt reports six original reference controls, two intended
wrong-oracle failures and twelve expected artifacts. The owning gate log names
all thirteen configured stages and ends `gates: OK`; the frozen summary reports
1,705 default tests, 64 additional feature tests and 139 consumer tests passed,
with ignored tests explicitly retained. These are reviewed receipts, not test
executions by this audit.
[Preflight](preflight-verification.json),
[oracle receipt](oracle-verification.json),
[gate log](workspace-gates.log),
[gate summary](validation.json)

Chronology is consistent: freeze **00:30:41.089 UTC**, native environment
**00:31:01.770 UTC**, first native attempt **00:31:03.456 UTC**. The environment's
precollection digest equals the actual manifest digest. This supports that
the primary native measurements began after the freeze; it does not establish
the completeness or success of future stage attempts.
[Freeze time](measurement-precollection.json),
[native environment](native/environment.json),
[attempt receipts](native/attempts.jsonl)

The remaining limits are unchanged: source/build correspondence relies on the
compiler/toolchain and retained build process; start/end hashes cannot detect
every hypothetical temporary midrun mutation; retained assertions and finite
controls are not a proof of all runtime behavior. Final conclusions still
require complete native/sink/anchor inventories, exact observations, all
adverse results, recomputed analysis and the final verifier.
