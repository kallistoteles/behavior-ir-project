# Behavior IR Project

Behavior IR aims to make AI-assisted information systems predictable and auditable. AI can
propose an operation through declared capabilities; a deterministic engine decides whether
the operation is valid. Behavior is an immutable, typed, content-addressed description of
valid state changes, with records that can be replayed.

This repository holds shared project orientation, purpose and agent guidance. The executable
semantics, implementation requirements and release contracts live in the repositories that
own them.

- [PURPOSE.md](PURPOSE.md) explains the problem, design principles and intended outcome.
- [AGENTS.md](AGENTS.md) tells agents how to navigate the project and make changes.
- [BRANCHING.md](BRANCHING.md) defines GitHub Flow with versioned releases across the repositories.

## Repositories and responsibilities

| Repository | Responsibility | Start here |
| --- | --- | --- |
| [behavior-ir-core](https://github.com/kallistoteles/behavior-ir-core) | Deterministic semantics: admission, types, hashing, evaluation, verification, persistence contract, replay and conformance fixtures. | [README](https://github.com/kallistoteles/behavior-ir-core/blob/main/README.md), [PRINCIPLES](https://github.com/kallistoteles/behavior-ir-core/blob/main/PRINCIPLES.md), [ARCHITECTURE](https://github.com/kallistoteles/behavior-ir-core/blob/main/ARCHITECTURE.md) |
| [behavior-ir](https://github.com/kallistoteles/behavior-ir) | Bindings and authoring syntax, examples, agent skills, models and the installable package. | [README](https://github.com/kallistoteles/behavior-ir/blob/main/README.md), [models](https://github.com/kallistoteles/behavior-ir/blob/main/models/README.md), [skills](https://github.com/kallistoteles/behavior-ir/blob/main/skills/README.md) |
| [behavior-ir-project](https://github.com/kallistoteles/behavior-ir-project) | Shared orientation and working guidance. | This README, [purpose](PURPOSE.md) and [agent instructions](AGENTS.md). |

**Core defines meaning. The ecosystem defines ways to author and use that meaning.**
The core has no dependency on the ecosystem. This documentation repository adds no runtime
dependency or separate semantic authority.

The core's supported consumer contract consists of the public `behavior-engine` Rust API,
the `behavior` CLI, versioned document formats and schemas, and conformance fixtures. Internal
core crates are implementation details. Ecosystem models lower completely and deterministically
to ordinary Behavior IR; they do not add hidden runtime behavior.

## Development and releases

Follow [the branch strategy](BRANCHING.md): reviewed feature branches merge into
`main`, and immutable tags identify published code releases.

The ecosystem's [core-release.json](https://github.com/kallistoteles/behavior-ir/blob/main/core-release.json)
declares its exact published Core Release. Committed dependency configuration, CI and release
builds use that release. Explicit, private, untracked overrides may support experimental
cross-repository development, but required gates, release verification and published artifacts
must always use the canonical dependency graph.

Run checks from the repository being changed, using its pinned Nix environment:

```bash
nix develop -c scripts/gates.sh
```

This command exists in each code repository. This documentation repository has
GitHub Actions checks for top-level Markdown local links, headings and whitespace;
run them locally with `python3 scripts/check-docs.py` and `git diff --check`.
It has no runtime build or release pipeline. Follow the owning repository's constitution,
feature specifications and scripts for the detailed requirements.

Local checkout names can differ from GitHub names. In the current workspace, the siblings are
`../behavior-ir-core` and `../behaviour-ir` (the ecosystem checkout). Confirm paths
and Git remotes before working in another repository.

## Project status and source of truth

The code repositories contain a working deterministic kernel and a Python authoring binding,
with verification, persistence and replay support. The models area includes rules and a worked
state-machine example. The broader AI-native information system is the project direction;
these documents do not claim that every proposed model, host integration or product is built.

Use the owning repository's specifications and tests to establish implemented behavior. Use
release metadata to establish compatibility. When working on the ecosystem, read core contracts
at its declared release revision; links to `main` above are navigation links, not version pins.
