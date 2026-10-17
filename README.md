# behavior-ir-project

General documentation and agent instructions for the Behavior IR project.

| Repository | Responsibility |
| --- | --- |
| [behavior-ir-core](https://github.com/kallistoteles/behavior-ir-core) | Authoritative semantics, deterministic execution, Store contracts, verification and governance. |
| [behavior-ir](https://github.com/kallistoteles/behavior-ir) | Python binding and DSL, Rust Model authority, composition, examples, consumer Skills and installable packages. |
| [behavior-ir-project](https://github.com/kallistoteles/behavior-ir-project) | Cross-repository status, completion criteria and issue follow-up. Implementation contracts remain with their owning repository. |

## Current baseline

**Checked:** 2026-10-17, against published **Behavior 0.13.0** (`v0.13.0`),
commit [`63f916c`](https://github.com/kallistoteles/behavior-ir/commit/63f916cbd9d999270f476e33267200e0aacd8696).

| Item | Status |
| --- | --- |
| Core release | [0.15.0](https://github.com/kallistoteles/behavior-ir-core/releases/tag/v0.15.0), commit `6b93898a9375113f7a8946f23ab5535319b6f5d6`, verifier **0.10.0**, Z3 **4.16.0**. Published and verified. |
| Ecosystem Core adoption | Feature **508** is [merged](https://github.com/kallistoteles/behavior-ir/pull/26) and shipped in Behavior 0.13.0. The released [pin](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/core-release.json) selects exactly Core 0.15.0; [main CI passed](https://github.com/kallistoteles/behavior-ir/actions/runs/39051411412) on the release commit. |
| Models | **StateMachine, RequestFlow, Approval and WorkQueue** are released in Behavior 0.13.0, including declaration identity [505](https://github.com/kallistoteles/behavior-ir/pull/23) and WorkQueue/state bindings [507](https://github.com/kallistoteles/behavior-ir/pull/25). |
| Python command authoring | Public `@command` and `emit` author durable intents. Hosts consume committed occurrences and own external delivery. |
| Purchase-approval conformance, 506 | **39 passed; complete.** C19 passes on the unchanged module with verifier 0.10.0. |
| WorkQueue conformance, 507 | **61 passed; all 12 obligations passed; complete**, subject to the documented proof and host assumptions. |
| Ecosystem package | [Behavior 0.13.0](https://github.com/kallistoteles/behavior-ir/releases/tag/v0.13.0) was published on 2026-10-17. Feature [509](https://github.com/kallistoteles/behavior-ir/pull/27) is delivered, including the package and updated consumer Skills. The published wheel targets Python **3.13+**, Linux **x86_64 / manylinux_2_28**. |

The [ecosystem release workflow](https://github.com/kallistoteles/behavior-ir/actions/runs/39053833380)
passed. The downloaded wheel, checksums and [release manifest](https://github.com/kallistoteles/behavior-ir/releases/download/v0.13.0/release-manifest.json)
were verified, including byte identity of the bundled Core CLI with the pinned
Core 0.15.0 asset. The release checks cover clean installation, the full conformance
suites, reproducible builds and the consumer Skill examples.

The checked-in [506/507 comparison and reports](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/specs/508-core-release-0-15/evidence/verification-comparison.md)
record the acceptance results. The original Approval BehaviorHash is unchanged;
both local uniqueness postconditions are proven. [Core #35](https://github.com/kallistoteles/behavior-ir-core/issues/35)
is closed. Global induction, initial-state validity and migration preservation
remain separate obligations.

Quick conformance mode deliberately omits some checks. Use the full/complete
reports when assessing completion; an unsupported, blocked or inconclusive result
does not count as a pass.

## Remaining completion work

The current conformance suites demonstrate the reference workflows through public
interfaces. They do not yet establish the entire ecosystem completion gate.
The next priorities are:

1. Demonstrate a durable reference backend and external command consumer,
   including process restart, conflicts, retries and idempotency.
2. Map all FC-01–FC-09 criteria to executable evidence and complete an independent
   application-development walkthrough from the published package. The release's
   clean-install smoke tests supply package evidence; the complete application
   acceptance gate remains separate.

WorkQueue governs work-state transitions. Scheduling, physical execution and
command delivery remain host/adapter responsibilities. Its availability does not
by itself satisfy the durable-integration criterion.

Neither Core feature completeness, ecosystem feature completeness nor production
readiness is declared by this status update.

## Project documents

- [Feature Completeness Roadmap](FEATURE-COMPLETENESS.md) — draft capability criteria, current evidence and remaining acceptance work.
- [Known issues](KNOWN-ISSUES.md) — owning trackers, resolved findings and release/adoption boundaries.
- [Model contracts and examples](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/models/README.md) — the four released Models, ownership rules and conformance boundaries in Behavior 0.13.0.
- Released consumer Skills: [authoring](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/skills/behavior-authoring/SKILL.md), [verification](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/skills/behavior-verification/SKILL.md) and [application integration](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/skills/behavior-application/SKILL.md).
