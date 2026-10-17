# Behavior IR — Feature Completeness Roadmap

**Status:** Draft for architectural agreement

**Scope:** Core + ecosystem

**Assessment date:** 2026-10-17

**Release baseline:** [Behavior **0.13.0**](https://github.com/kallistoteles/behavior-ir/releases/tag/v0.13.0),
commit [`63f916c`](https://github.com/kallistoteles/behavior-ir/commit/63f916cbd9d999270f476e33267200e0aacd8696),
bundling Core **0.15.0** / verifier **0.10.0**. Release feature **509** is delivered.

**Goal:** Define when the system is functionally complete, independently of production hardening.

> Behavior IR is feature complete when a developer can define a domain-specific data
> model and its behaviors, execute them safely against persistent state, evolve the
> system, and subsequently verify what happened and why, without changing Core or
> implementing separate decision semantics.

This is a capability-based definition. It does not require every useful Model,
language binding, adapter or business application to exist. StateMachine,
RequestFlow, Approval and WorkQueue illustrate abstractions built above the semantic Core.

## 1. Scope and milestones

Behavior IR shall provide a domain-independent foundation for building
deterministic, verifiable information systems. The data model remains
domain-specific; Core does not impose a universal business object model.

Feature completeness is evaluated against explicitly supported classes of systems,
not every imaginable business requirement. Three milestones must remain distinct:

| Milestone | Completion boundary |
| --- | --- |
| **Core feature complete** | The documented semantic foundation can describe, execute and verify supported domain behaviors. Its semantic, Store and command-intent contracts are explicit and demonstrated by executable Core conformance tests. A real database or command adapter is not required inside Core. |
| **Ecosystem feature complete** | A developer can build a complete system through public APIs, Models and adapters. This requires the end-to-end capabilities and completion gate below, including an actual durable reference backend and external command consumer. |
| **Production ready** | The system is sufficiently hardened, documented and operationally proven for its intended production use. This is a separate assessment beyond functional completeness. |

Core's contracts may be sufficient for another component to implement durable
storage and command delivery. For ecosystem completeness, the reference integration
must actually exist and pass acceptance tests. Formal contracts alone do not meet
FC-06.

## 2. Completion matrix

| Capability | Planning assessment | Feature-complete criterion |
| --- | --- | --- |
| **Typed semantic Core** | Implemented | Types, expressions, predicates, transitions, invariants and exact arithmetic operate consistently. |
| **Domain data and queries** | Implemented | Entity lifecycle, references, relational queries and derived values support nontrivial domains. |
| **Reads and actions** | Implemented | Both have explicit capabilities, deterministic results and appropriate records. |
| **Persistence and concurrency** | Core contract and reference-backend conformance exercised; durable integration not yet demonstrated by the cited evidence | An actual durable backend passes conformance and survives restart, conflict and retry tests. |
| **History and schema evolution** | Implemented | Committed histories replay across supported schema migrations. |
| **Verification and governance** | Implemented; verifier 0.10.0 proves the original C19 local uniqueness obligations | Static verification, historical verification, signed governance evidence and commit policy have tested contracts. |
| **Compositional Models** | 501–503, declaration identity 505, and WorkQueue/state bindings 507 are delivered in Behavior 0.13.0 | Models lower deterministically, compose and preserve identity and ownership rules. |
| **Cross-layer conformance** | 506 full: 39 passed; 507 full: 61 passed and 12 obligations passed; both complete and rechecked by release 509 | Independent authoring and consumption paths reproduce specified results. |
| **External command integration** | Core intents and WorkQueue exist; a durable command-consumer reference integration remains to be demonstrated | A reference host safely consumes committed commands, with explicit retry and idempotency behavior. |
| **Developer experience** | Behavior 0.13.0 publishes the Python DSL, command authoring, CLI, four Models and updated consumer Skills; clean-install and example checks pass | A developer can build and evolve a complete application through supported public interfaces. |

The assessment combines merged source, checked-in conformance reports and release
evidence. It does not declare the full FC-01–FC-09 gate passed. In particular,
backend conformance in memory does not establish restart durability, and committed
command evidence does not establish delivery to an external system.

### Current acceptance evidence

- [Core 0.15.0](https://github.com/kallistoteles/behavior-ir-core/releases/tag/v0.15.0)
  is published at commit `6b93898a9375113f7a8946f23ab5535319b6f5d6` with verifier
  0.10.0 and Z3 4.16.0. Its [release workflow](https://github.com/kallistoteles/behavior-ir-core/actions/runs/39033400230)
  passed; downloaded assets match the independent local reproducible build.
- [Ecosystem 508](https://github.com/kallistoteles/behavior-ir/pull/26) adopts that
  exact release and its asset checksums. Behavior 0.13.0 retains the pin;
  [main CI](https://github.com/kallistoteles/behavior-ir/actions/runs/39051411412)
  passed on the release commit above. Core [#29](https://github.com/kallistoteles/behavior-ir-core/issues/29),
  [#31](https://github.com/kallistoteles/behavior-ir-core/issues/31) and
  [#35](https://github.com/kallistoteles/behavior-ir-core/issues/35) are closed;
  the corresponding ecosystem readiness registry is empty.
- The [506 full report](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/specs/508-core-release-0-15/evidence/0.15.0-506-full-report.json)
  records **39 passed, zero blockers, complete**. C19 verifies the original module
  `sha256:a04ba37ab89e051e448abb760bd754bbb0955125fd22ba8da927b8529a531779`;
  both action-qualified uniqueness checks are proven. Its fresh report identity is
  `sha256:d862a01023de26adf951b9c6dc7a3f36707b183d028fe4ad1a000b7c7c482d34`.
- The [507 full report](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/specs/508-core-release-0-15/evidence/0.15.0-507-full-report.json)
  records **61 passed and all 12 obligations passed, complete**. Its obligations
  retain explicit assumptions about trusted time, migrations and host behavior.
  These are not all global SMT theorems.
- The [508 comparison](https://github.com/kallistoteles/behavior-ir/blob/v0.13.0/specs/508-core-release-0-15/evidence/verification-comparison.md)
  records unchanged semantic snapshots, removal of binding snapshot-completion
  workarounds and C19's change from blocked to passed. It preserves old reports as
  historical evidence. Quick mode still omits checks and cannot replace complete mode.

[Behavior 0.13.0](https://github.com/kallistoteles/behavior-ir/releases/tag/v0.13.0)
was published on 2026-10-17 by [release 509](https://github.com/kallistoteles/behavior-ir/pull/27).
Its [release workflow](https://github.com/kallistoteles/behavior-ir/actions/runs/39053833380)
passed, including full conformance, clean no-Rust installation, installed-version
and output checks, consumer Skill examples and reproducible wheel builds.
The downloaded wheel and manifest match the published checksums; the bundled
Core CLI is byte-identical to the pinned Core 0.15.0 asset. The released wheel
targets Python 3.13+ on Linux x86_64 / manylinux_2_28.

This supplies published-package acceptance evidence. It does not establish the
durable reference integration or independent complete-application walkthrough
required below. Core, ecosystem and Model semantic versions remain independent.

## 3. Mandatory end-to-end capabilities

The following capabilities define **ecosystem** feature completeness. Core's
milestone is assessed against its own supported semantic domain and executable
contracts, rather than requiring all ecosystem components to be implemented in Core.

### FC-01 — Define a system

A developer can define domain-specific entities, values, relationships, invariants,
reads and transitions without modifying Core.

### FC-02 — Compose behavior

Models and ordinary authored behavior can coexist in the same admitted module.
Model composition must be deterministic, with explicit dependencies, identities
and effect ownership.

### FC-03 — Execute safely

The system evaluates against an authoritative state and commits through the
documented Store contract. Invalid inputs, stale evidence, invariant violations
and conflicting commits must not produce invalid committed histories.

### FC-04 — Preserve and evolve history

A developer can change both behavior and schema through supported versioning and
migration mechanisms. Historical state and recorded decisions remain reproducible
under their applicable semantic versions.

### FC-05 — Verify correctness

The system supports independently reported:

- Static verification within the supported SMT model.
- State reconstruction (`replay_data`).
- Historical decision reproduction (`replay_behavior`).
- Evidence and integrity validation.
- Applicable commit and governance verification.

Unsupported proof obligations must never be reported as passed.

Core semantics is authoritative. Execution optimizations must preserve observable
semantic results; proof abstractions must conservatively include all concrete
behaviors under justified assumptions. A local postcondition proof does not
establish global induction, initial-state validity or migration preservation.
See the [Core verification contract](https://github.com/kallistoteles/behavior-ir-core/blob/v0.15.0/docs/verification.md#parent-count-congruence-verifier-010).

### FC-06 — Integrate with real infrastructure

At least one reference application uses a durable storage backend and an external
command consumer. Persistence survives process restart; conflict and retry behavior
is exercised through the public integration contracts.

External effects remain outside deterministic evaluation. Command dispatch,
acknowledgement, retries and idempotency are explicitly assigned to the host or
adapter layer. This requirement does not add database access or command execution
to Core's semantic evaluator.

### FC-07 — Expose trusted capabilities

An external client, including an AI-based interface, can request declared read or
action capabilities without directly controlling authoritative state or trusted
execution context. Core and the trusted host retain decision authority.

A simulated AI or client intent is sufficient for automated conformance. A
particular LLM provider is not required.

### FC-08 — Reproduce across interfaces

The same supported workflow can be independently authored through Python and Rust
Model interfaces. Equivalent admitted modules produce matching semantic identities.
The public Python engine interface and pinned Core CLI agree on specified
evaluation outcomes.

### FC-09 — Build without private workarounds

A reference application can be built, run, migrated, replayed and verified using
supported public APIs. No manual modification of generated IR, private binding
logic or duplicated Core semantics is needed.

## 4. Reference applications

Feature completeness shall be demonstrated by two structurally different examples.

### Reference A — Purchase approval

Exercises StateMachine, RequestFlow, Approval, actor eligibility, concurrent
decisions, derived status, reads, committed history and verification.

Feature 506 now supplies executable evidence for its reference workflow: all 39
full-mode checks pass under the adopted Core 0.15.0 pin, including C19. It exercises
in-memory and Python reference backends, not a demonstrated durable database or
external command executor. Its suite's completion does not establish all FC criteria.

### Reference B — Domain state and financial operations

Exercises ordinary Core primitives without depending on Models: exact
numeric values, entity references, relational queries, constraints, schema
migration and durable command intents. Existing accounts, ledger or order examples
can provide the starting point.

Together the examples demonstrate higher-level modeling and direct semantic
authoring. Across the reference applications, the acceptance evidence must cover
all FC-01–FC-09 capabilities, including actual durable storage and command consumption.

## 5. Explicit non-goals

The following are not requirements for feature completeness:

| Capability | Reason |
| --- | --- |
| WorkQueue Model | Implemented by 507. It adds supporting evidence but does not supply durable execution or scheduling; additional Models are not themselves completion criteria. |
| TaskScheduler Model | A possible addition; not required for the defined completion gate. |
| Graphical UI | Can be built independently. |
| A universal domain data model | Contrary to domain-specific data modeling. |
| Additional language bindings | Python and Rust are sufficient to establish the initial contracts. |
| Distributed worker orchestration | Belongs to infrastructure and adapters. |
| Built-in LLM or autonomous agent | AI is a possible interface, not a semantic authority. |
| Multiple database implementations | One conforming durable reference implementation is sufficient. |
| Performance optimization | Production hardening, unless performance prevents completion of the reference applications. |
| Formal proof of the entire implementation | Stronger than the defined verification contracts. |

These capabilities may be developed later without reopening the agreed
feature-complete definition.

## 6. Completion gate

**Ecosystem feature complete** is declared only when:

1. All mandatory capabilities FC-01–FC-09 are demonstrated by executable acceptance tests.
2. Both reference applications run from a clean installation using pinned release artifacts.
3. All relevant conformance suites pass in CI.
4. No known unresolved defect violates a required semantic or integrity contract.
5. Verification limitations and trust assumptions are explicitly documented.
6. The project has a published public-API and versioning contract.
7. A developer can follow the documentation without relying on undocumented implementation knowledge.

The acceptance evidence must map each FC identifier to its reference scenario,
expected result, executable test and CI result, together with the exact release
artifacts and source revisions used. An implementation-status label or closed issue
alone cannot satisfy this gate.

**Feature complete does not imply production ready, API stability, or a
general-purpose distributed application platform.**

## 7. Proposed sequence

| Phase | Deliverable | Current status and remaining work |
| --- | --- | --- |
| 1 | Core release + source alignment | Core 0.15.0 is published; adoption 508 is merged and CI is green. |
| 2 | Model identities and cross-layer conformance | 505 and 506 are merged; 506 complete passes. WorkQueue 507 supplies additional complete conformance evidence. |
| 3 | Ecosystem release and consumer Skills, 509 | Delivered: Behavior 0.13.0 is published with green release checks, verified artifacts and updated consumer Skills. |
| 4 | Durable reference integration | Remaining: demonstrate real storage and command consumption with restart, conflict, retry and idempotency evidence. |
| 5 | Developer acceptance and evidence mapping | Remaining: map FC-01–FC-09 to pinned tests/results and verify clean-install usability before declaring completion. |

Future features should be evaluated against this roadmap. A feature is mandatory
before feature complete only if its absence prevents an explicitly required
capability from being implemented correctly using existing public contracts.

The current priority is **durable end-to-end application → FC evidence mapping
and developer acceptance → feature complete**. Existing release, Model and
conformance work is reused. Additional Models or scheduling capabilities are
required only if a demonstrated gap prevents one of the defined FC capabilities.

## 8. Governing principle

**Feature complete means all defined foundational capabilities have been
demonstrated. It does not mean every useful feature has been implemented.**

The project can continue adding Models, bindings and tools after this gate without
making completion of the foundational platform an indefinitely moving target.
