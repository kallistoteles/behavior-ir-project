# Branch strategy

Follow [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow)
with versioned releases across all three repositories. `main` contains reviewed,
validated development and may include work awaiting release. Immutable tags identify
published releases. We use no permanent `dev`, `develop` or `test` branches.

## Development

| Repository | Working branches | Release policy |
| --- | --- | --- |
| `behavior-ir-project` | `docs/<topic>` | Documentation merges into `main`; no regular release pipeline. |
| `behavior-ir-core` | Numbered Spec Kit features from `012`, or `fix/<topic>` | Independent Core releases tagged `vX.Y.Z`. |
| `behavior-ir` | Numbered Spec Kit features from `500`, or `fix/<topic>` | Independent package releases tagged `vX.Y.Z`, with an exact published Core pin. |

Preserve existing historical feature numbers.

1. Branch from current `main` for each focused change and open a draft PR early.
2. Keep requirements, implementation and verification evidence consistent. Complete
   the owning repository's checks and review before merging into `main`.
3. Use separate worktrees for parallel features. Link dependent PRs, state their
   bases, merge dependencies first, and revalidate against the updated base.
4. Prefer merge commits for Core work whose evidence references commit identities.
   Delete merged branches when dependent PRs and active worktrees no longer need them.

Protect `main` with PRs and required checks where available; prohibit force pushes
and deletion. For project documentation, check claims and external links, run
`python3 scripts/check-docs.py` and `git diff --check`; CI repeats the automated checks.
Keep audit evidence and remediation in separate PRs.

## Releases and dependencies

Merging does not publish a release. Use the owning repository's release scripts,
validate the exact revision being published, and never move or reuse release tags.
Core and ecosystem release versions do not need to match.

For changes spanning repositories, publish Core first. Then update the ecosystem's
`core-release.json` and dependency metadata through a tested PR against that published
release. Update shared project explanations as needed. Unreleased Core experiments
remain private and cannot satisfy required ecosystem gates.

Create a maintenance branch from a released tag only when an older supported release
line needs patches; carry applicable fixes forward to `main`.

The owning constitutions and release contracts remain authoritative; see
[development and releases](README.md#development-and-releases).
