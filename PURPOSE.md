# Project Purpose

Behavior IR exists to let people use AI to interact with information systems while keeping
the decisions that govern state changes explicit, deterministic and reviewable.

Natural language is useful for expressing intent. It is a poor authority for deciding whether
money may move, an invoice may be approved, an entity may be removed, or an invariant still
holds. The project puts that authority in typed behavior definitions and a deterministic
engine. An AI proposal reaches the system through a declared capability and passes the same
checks as any other caller.

## Intended outcome

Given the same admitted behavior version, state and explicit inputs, the engine produces
the same result and canonical records. A reviewer can inspect what was requested, which
rules applied, what changed and why. A later run can replay those records without consulting
the AI that originally proposed the request.

For example, AI may propose approving an invoice. The behavior definition determines who
may approve it, the applicable amount limit and the invariants that must still hold. The
trusted host supplies the acting identity and state. The engine accepts or rejects the
operation and records the result; fluent model output does not grant permission.

## Design commitments

- **One semantic authority.** Core owns typing, admission, evaluation, hashing, verification,
  persistence semantics and replay. Bindings and higher-level models use those semantics.
- **Untrusted input becomes typed behavior.** Wire documents pass admission before use.
  Authoring syntax must finish through the same semantic contract.
- **Behavior has a content identity.** Canonical semantic content identifies the admitted
  behavior version, independent of incidental wire formatting.
- **Changes are checked before commitment.** Evaluation checks the current state, applicable
  preconditions, the proposed changes, postconditions and resulting invariants.
- **Numeric decisions are exact.** Lossy conversion and rounding are explicit. Verification
  and evaluation must agree on the numeric model.
- **Evidence is inspectable.** Decision records, verification findings and conformance
  fixtures make claims testable. An inconclusive verification result is never reported as
  a proof.
- **State and external inputs are explicit.** Hosts supply identity, state, time, facts and
  storage integration where the contract requires them. Hidden environment state must not
  determine the engine's result.
- **Convenient authoring preserves meaning.** A model can generate and compose ordinary IR.
  If a construct requires new evaluator semantics, it needs an explicit core proposal.

These are an orientation to the project's design. The detailed normative definitions are
the core's [PRINCIPLES.md](https://github.com/kallistoteles/behavior-ir-core/blob/main/PRINCIPLES.md),
[ARCHITECTURE.md](https://github.com/kallistoteles/behavior-ir-core/blob/main/ARCHITECTURE.md)
and the owning repositories' constitutions and feature contracts.

## Reproducible delivery

Our [branch strategy](BRANCHING.md) uses GitHub Flow with versioned releases:
`main` holds accepted development, while immutable tags identify published releases.

Confidence depends on more than deterministic evaluation. Required gates must validate the
supported dependency graph; consumers must build through the public contract; and releases
must identify an immutable source revision. Release checks and consumer validation precede
final artifact construction and publication. Publication is the last step.

The ecosystem therefore recognizes one dependency graph: the exact Core Release declared
in its release metadata. Developers may experiment privately against a local core checkout,
but those experiments cannot satisfy project gates or produce project releases. This keeps
cross-repository development practical while preserving a reproducible supported build.

## What success looks like

A user can express intent through a convenient interface and still receive a decision governed
by inspectable rules. Different authoring paths yield equivalent admitted IR and hashes.
Changes can be checked against invariants, decisions can be replayed, and an external consumer
can use a release without depending on internal implementation details.

The kernel and ecosystem are the foundation for that outcome. Product-specific interfaces,
hosts, storage backends and higher-level models remain explicit integration work. Describe
their actual implementation status from specifications and evidence, rather than inferring
completion from the project vision.
