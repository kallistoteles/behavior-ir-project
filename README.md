# behavior-ir-project

General documentation and agent instructions for the Behavior IR project.

| Repository | Responsibility |
| --- | --- |
| [behavior-ir-core](https://github.com/kallistoteles/behavior-ir-core) | Authoritative semantics, deterministic execution, Store contracts, verification and governance. |
| [behavior-ir](https://github.com/kallistoteles/behavior-ir) | Python binding and DSL, Rust Model authority, composition, examples, consumer Skills and installable packages. |
| [behavior-ir-project](https://github.com/kallistoteles/behavior-ir-project) | Cross-repository status, completion criteria and issue follow-up. Implementation contracts remain with their owning repository. |

## Current baseline

**Checked:** 2026-10-17, against ecosystem revision
[`3f28bde`](https://github.com/kallistoteles/behavior-ir/commit/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5).

| Item | Status |
| --- | --- |
| Core release | [0.15.0](https://github.com/kallistoteles/behavior-ir-core/releases/tag/v0.15.0), commit `6b93898a9375113f7a8946f23ab5535319b6f5d6`, verifier **0.10.0**, Z3 **4.16.0**. Published and verified. |
| Ecosystem Core adoption | Feature **508** is [merged](https://github.com/kallistoteles/behavior-ir/pull/26). Its [pin](https://github.com/kallistoteles/behavior-ir/blob/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5/core-release.json) selects exactly Core 0.15.0; [main CI passed](https://github.com/kallistoteles/behavior-ir/actions/runs/39042261046). |
| Models | **StateMachine, RequestFlow, Approval and WorkQueue** are implemented on ecosystem main. Declaration identity [505](https://github.com/kallistoteles/behavior-ir/pull/23) and WorkQueue/state bindings [507](https://github.com/kallistoteles/behavior-ir/pull/25) are merged. |
| Purchase-approval conformance, 506 | **39 passed; complete.** C19 passes on the unchanged module with verifier 0.10.0. |
| WorkQueue conformance, 507 | **61 passed; all 12 obligations passed; complete**, subject to the documented proof and host assumptions. |
| Ecosystem package | Latest published release is [Behavior 0.12.0](https://github.com/kallistoteles/behavior-ir/releases/tag/v0.12.0). Release preparation **509**, targeting **Behavior 0.13.0** with Core 0.15.0, is in progress. These source capabilities are not yet established as a published ecosystem package. |

The checked-in [506/507 comparison and reports](https://github.com/kallistoteles/behavior-ir/blob/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5/specs/508-core-release-0-15/evidence/verification-comparison.md)
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

1. Finish the ongoing ecosystem release and verify its installed artifacts,
   bundled Core and consumer Skills.
2. Demonstrate a durable reference backend and external command consumer,
   including process restart, conflicts, retries and idempotency.
3. Map all FC-01–FC-09 criteria to executable evidence and complete an independent
   developer walkthrough from a clean installation.

WorkQueue governs work-state transitions. Scheduling, physical execution and
command delivery remain host/adapter responsibilities. Its availability does not
by itself satisfy the durable-integration criterion.

Neither Core feature completeness, ecosystem feature completeness nor production
readiness is declared by this status update.

## Project documents

- [Feature Completeness Roadmap](FEATURE-COMPLETENESS.md) — draft capability criteria, current evidence and remaining acceptance work.
- [Known issues](KNOWN-ISSUES.md) — owning trackers, resolved findings and release/adoption boundaries.
- [Model contracts and examples](https://github.com/kallistoteles/behavior-ir/blob/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5/models/README.md) — the four implemented Models, ownership rules and conformance boundaries at the assessed source revision.
