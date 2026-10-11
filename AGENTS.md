# Agent Instructions

## Scope and orientation

These instructions apply to this documentation repository. They also provide shared
orientation when a task spans the Behavior IR project. Read [README.md](README.md) and
[PURPOSE.md](PURPOSE.md), then inspect the repository that owns the requested change.

Follow explicit user instructions and the applicable instructions in that repository.
Read its `AGENTS.md` if present, `.specify/memory/constitution.md`, relevant architecture
documents and feature artifacts. This repository does not replace an owning repository's
constitution or establish a new semantic or release contract.

Confirm the working directory and Git remote. The usual local siblings are
`../behavior-ir-core` and `../behaviour-ir`; the latter's GitHub name is
`behavior-ir`. Do not assume that a directory's name identifies its responsibility.

Follow [BRANCHING.md](BRANCHING.md): work on focused branches, use PRs into `main`,
and keep release publication separate from merging. Use separate worktrees for
parallel features and make dependencies between PRs explicit.

## Put changes in the repository that owns them

- **Core:** semantic primitives, typing, admission, evaluation, hashing, verification,
  persistence contract, replay, schemas, conformance fixtures and public engine API.
- **Ecosystem:** bindings, authoring syntax, deterministic model lowering, examples,
  consumer skills and packaging against a published Core Release.
- **Project:** shared explanations, purpose, navigation and agent guidance.

For a new construct, ask whether the evaluator must understand it for the meaning to be
correct. If yes, propose it explicitly in core. If it can lower faithfully to existing IR,
implement it as an ecosystem model, library or tool. Record semantic gaps instead of adding
hidden host behavior, silent approximations or a second evaluator.

Use `behavior-engine` as the supported Rust consumer API. Do not import internal core crates
into an ecosystem binding or copy core schemas and fixtures into the ecosystem. Follow the
owning scripts for fetching the declared release's conformance assets.

## Dependency and release discipline

Committed ecosystem dependency metadata, required gates and release builds must use the
exact Core Release declared in `core-release.json`. Repository-tracked core path dependencies
and patch overrides are forbidden.

A developer may use an explicit local, untracked override for cross-repository experiments.
Keep it outside official build and validation paths, in a separate checkout and build
environment. Restore the canonical metadata and rebuild against the published release before
running required gates. Do not add a development bypass to official scripts or claim that
an override build proves release compatibility.

Core changes needed by an ecosystem feature must become a Core Release before the ecosystem
lands its supported dependency on them. Public API changes need conformance and consumer
evidence. Release validation must cover the exact revision being published. Do not move or
reuse release tags; test version/tag refusal in disposable repositories. Complete checks,
consumer validation and final artifact construction before publication.

Creating or editing these project documents does not itself authorize tagging or publishing
a release. Carry out delivery actions when they are within the user's requested scope.

## Work from requirements and preserve evidence

Use the relevant feature's `spec.md`, `plan.md`, `tasks.md` and contracts when present.
Follow the owning repository's Spec Kit workflow when it is part of the task. New core
features use numbers 012 onward; new ecosystem features use 500 onward. Preserve existing
historical numbering and name the repository in cross-references.

Keep requirements, implementation tasks and verification evidence consistent. Mark a task
complete only after doing and verifying its work. Respect review-owned or read-only
checklists; place implementation evidence in an appropriate separate artifact when required.

New implementation code, including deterministic release scripts, follows the owning
constitution's test-first requirements: write the relevant test and observe it fail before
implementing the behavior. Test error propagation, ordering and refusal paths as well as
successful output. New tests cannot establish past test-first compliance; record missing
historical evidence honestly.

Models need evidence that tests are actually collected and that incorrect lowering fails
the shared gate. Equivalent authoring paths must agree on admitted IR and hashes. Never
report an inconclusive proof or a skipped check as a passing result.

## Make and verify focused changes

Inspect `git status` before editing. Preserve unrelated user changes and untracked work.
Use explicit file lists for staging and isolated worktrees when that helps separate delivery.
Do not reset, clean or broadly stage a workspace to simplify the task. Search with `rg`
and read relevant existing code before introducing new abstractions.

Run the owning code repository's required checks in its pinned environment, from its root:

```bash
nix develop -c scripts/gates.sh
```

Use the canonical repository scripts and required CI checks. Do not weaken gates, bypass
branch protection or substitute private overrides to obtain a green result. Verify that
results cover the actual revision being delivered. For documentation-only changes here,
check factual claims and links, run `python3 scripts/check-docs.py` and `git diff --check`;
there is no runtime test suite. When changing documentation tooling, also run
`python3 -B -m unittest discover -s scripts/tests -p 'test_*.py'`.

Explain the outcome, relevant validation and any remaining work. Distinguish locally
created files, committed changes, merged changes and published releases. Continue work
already authorized by the user without repeatedly requesting the same approval.

## Keep project information maintainable

Write technical documentation in English unless the task asks otherwise. Link to the
canonical contract rather than copying large normative sections here. Use the ecosystem's
pinned core revision when checking compatibility; a navigation link to `main` is not a pin.

Avoid embedding transient release versions, test counts or CI status in shared orientation.
Distinguish implemented capabilities, worked examples and planned product features. Update
the README, purpose and these instructions together when their shared explanation changes.
