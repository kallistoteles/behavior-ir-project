# Execution and evidence from first principles

**Date:** 2026-10-28. **Core baseline:** `fc73fa36b959aeaf54cff2f38dd190c4389c3fa1`. **Scope:** architectural research derived from requirements, not from a preferred implementation. No production code, dependencies, proof builds, tests or performance experiments were introduced in this turn. Prior uncommitted research and published evidence remain unchanged.

## Conclusion before technology

The problem is:

> Establish that an explicitly defined operation produced the correct observable result from the correct complete operational inputs; avoid repeating work whose validity is already justified; retain enough information for the promised reconstruction.

This statement does not entail Git, Merkle trees, a dependency graph, DBSP or Nova. It implies semantic correctness, justified reuse, explicit trust boundaries and sufficient retained information. Storage layout, incremental algorithms and cryptographic proof systems are choices for satisfying those obligations.

The previous report's hybrid remains a candidate, but calling it the leading architecture before fixing these obligations was premature. The next research comparison should include inductively maintained semantic views, certifying transition checkers and verified incremental compilation as independent starting points. Succinct history proofs are an additional requirement/backend choice, not the definition of Core execution.

## 1. What is the state that determines the next result?

Let `Ω` denote the operational information needed for the next transition. It includes more than live business entities:

- live entity values;
- historical identity use/lifetimes, including removed identities;
- exact lineage/history head and the schema/module/policy facts required at that boundary;
- any further authoritative information that changes the specified decision or event identity.

A derived index is not automatically new authoritative state: it can be an implementation of a function of Ω. Its interpretation and reconstruction must be specified.

**Our finite example, derived from the existing identity rule:** starting from the same empty genesis, history A creates then removes `x`; history B creates then removes `y`. Both end with empty live state at position 2, but creating `x` next is forbidden in A and may be allowed in B. Equal live-content StateId and equal position therefore do not identify equivalent operational inputs. The exact histories differ. This is an explanatory case, not a newly executed test. Existing [identity checks](../../../../crates/behavior-store/src/store.rs) reject reused identities, and the [persistence contract](../../../../docs/persistence.md) separates content identity from historical identity.

Thus reducing live-state size does not necessarily bound historical identity metadata or audit retention. A design must account for them instead of dropping them from its model.

## 2. Define the function and observation before the proof

For exact admitted semantics M and fully specified input I, write:

`F_M(Ω,I) = (decision, Ω_next, ordered_commands, error, normative_observations)`.

I includes the request, bindings and contextual/external data relevant to the claim. The committed event additionally binds the original publication metadata required by its contract. A denied/error request does not silently become a committed state change. Determinism presupposes that every relevant source of variation is fixed. [Schneider's state-machine model](https://www.cs.cornell.edu/fbs/publications/SMSurvey.pdf) supplies the conceptual foundation; its determinism premise is not a proof that a particular implementation records every input.

Separate four correctness statements:

1. **Exact execution:** the result equals F for these exact inputs.
2. **Safety:** a selected property holds in the required states/transitions.
3. **Authority/provenance:** the inputs and permission claims are linked to accepted sources and the original event.
4. **Reconstruction:** the consumer can obtain enough information to recover the promised state, command history or audit view.

They are not interchangeable. Our example: an `increment` from zero returning two preserves nonnegativity but executes the wrong transition. Two command-only histories can have equal final business state and different effects. A signed or correctly computed observation does not establish physical-world truth without its source assumptions. [Lamport's invariance/refinement distinction](https://lamport.azurewebsites.net/tla/book-02-08-08.pdf), [authentication/authority foundations](https://bwlampson.site/45-AuthenticationTheoryAndPractice/Acrobat.pdf).

In a greenfield design, distinguish application execution meaning from evidence encoding. Existing published hashes/profiles remain compatibility obligations. Their immutability does not make a particular JSON layout a mathematical requirement for future versions.

## 3. What information must be retained?

Retention is relative to the consumer's reconstruction target. A representation is insufficient if it identifies two histories for which the promised reconstructed answers differ.

- State reconstruction may use accepted genesis plus sufficient ordered transition data.
- Execution re-evaluation also requires the applicable semantics and original inputs/context, or an equivalent reconstructible representation.
- Command replay requires occurrence order and multiplicity, even when state is unchanged.
- Provenance review requires the relevant origin/authority evidence.
- A full audit export requires the information that determines its observations and historical interpretation.

Values can be shared, compressed, referenced or derived. A reference is sufficient only with a retrieval/reconstruction contract. A statement that data exists is not a service that returns it. Proofs of retrievability themselves define additional extraction and adversary assumptions; they do not imply permanent network availability. [Juels–Kaliski](https://www.arijuels.com/wp-content/uploads/2013/09/JK07.pdf).

This yields a concrete design freedom: a complete audit view need not be physically repeated inside every event. It does not justify discarding information needed to reproduce that view. The system can retain a sufficient history representation and construct the view when requested, under an explicitly versioned contract.

## 4. What work is necessary, and what is merely repeated?

The following are our bounded reasoning examples, not universal complexity theorems:

- A cold black-box checker deciding whether four unknown bits are all zero cannot distinguish `0000` from `0001` after observing only the first three zeros. A correct maintained count changes that information premise.
- Maintaining the count requires correct initialization and an update law covering every change. Hashing the count does not establish that law.
- Changing one global limit can change the validity of many entities; changing one cell is not equivalent to affecting one obligation.
- Conversely, checking a new entity against a local total rule need not revisit unchanged entities once the exact prior validity and dependency premises are established.

Dynamic complexity explicitly separates initial structures, update functions and maintained queries. Its complexity results do not automatically imply sequential Core runtime bounds. [Patnaik–Immerman](https://people.cs.umass.edu/~immerman/pub/dynfo.pdf).

Let D be all affected semantic dependencies, not merely written cells. A useful design targets work proportional to necessary affected computation and requested output. It must measure initialization, steady updates, reconstruction and verifier work separately. No supported theorem here says every admitted Core program has a delta-only evaluation strategy.

If a consumer explicitly requests B bytes, producing those bytes takes proportional output work. If the consumer requests only a decision or a proof, B need not be the expanded trace size. These are different interfaces and claims, not interchangeable benchmark outputs.

## 5. The reusable mathematical object is a maintained meaning

Let C contain derived information: indexes, query summaries, retained intermediate values or prior validity results. Define an exact relation:

`J_M(Ω,C)`: every retained component has its declared meaning for this operational state and semantic context.

The obligations are:

```text
Initialization: Init_M(Ω) produces C satisfying J_M(Ω,C).

Update: J_M(Ω,C) plus an accepted complete transition/update
        yields the exact F_M result and J_M(Ω_next,C_next).

Recovery: rebuilding from retained authoritative information
          restores the same required meaning before reuse.
```

For a query view, J must establish equality with the complete query result, not merely that returned members pass. For count, it establishes exact cardinality. For a reverse-reference index, it covers every incoming edge. Query emptiness and missing references are dependencies too: a new matching entity can invalidate an old empty answer without changing any old returned row. [Authenticated query correctness/completeness/freshness](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf).

A positive-row list, a root hash and a producer's “complete” label do not prove J. Unknown dependencies require conservative recomputation or a genuinely justified alternative. Rules involving captures/context require those inputs in the maintained meaning as well.

This formulation gives a starting point smaller than a general new runtime/proof framework: define exact views for a minimal rule fragment and prove initialization/update correspondence. Pure caches remain reconstructible; Safety Model/Lean certificates remain build-time artifacts and introduce no hidden business state.

## 6. The verifier can be smaller than the producer

A producer may compute a proposed result y with a witness w. A checker K is useful if its proved acceptance rule is:

`J_M(Ω,C) and K(M,Ω,C,I,y,w)=accept`

`implies y=F_M(Ω,I) and J_M(Ω_next,C_next)`.

The input state can be local authoritative data or authenticated openings under an independently justified anchor. The latter introduces additional binding/coverage obligations. An untrusted producer cannot manufacture the prior-validity premise through a private Rust type or a claimed root.

This is the **certifying algorithm** model. The mathematical witness implication, the checker's concrete implementation and its data representation each need justification. Existing work demonstrates this separation with verified executable checkers; it does not guarantee that a small efficient checker exists for every Core construct. [Verification of Certifying Computations](https://people.mpi-inf.mpg.de/~mehlhorn/ftp/VerificationCertComps.pdf).

CompCert supplies a precise precedent: an external register allocator proposes a transformation, and a verified validator checks structural coverage and semantic relations. This proves accepted transformations for that pass, not arbitrary executions. A checker may reject some valid proposals; Core must then preserve its public result through a sound fallback rather than turn witness rejection into business DENY. [Validator](https://compcert.org/doc/html/compcert.backend.Allocation.html), [correctness development](https://compcert.org/doc/html/compcert.backend.Allocproof.html).

## 7. Continued research: three architectures derived from these obligations

| Starting point | What is established once | What happens on an update | Main remaining Core obligation |
|---|---|---|---|
| **Inductively maintained semantic views** | Exact J and maintenance correctness for the supported algebra | Execute the update algorithm and preserve J | Complete views/dependencies, full observable result, initialization and recovery |
| **Untrusted executor plus verified transition checker** | Sound acceptance calculus and checker implementation | Check an independently supplied derivation | Full obligation coverage and sufficiently efficient witnesses/fallback |
| **Verified incremental compilation/cache transfer** | Correct translation and change laws for primitives | Execute derived change programs and update retained intermediates | Mapping Core's numeric/error/order semantics into the proved language |

These are alternatives at different seams. A design need not combine all of them. An ordered dependency graph or object DAG may implement parts of them, but neither is the defining theorem.

The new primary-source review found:

- **Incremental λ-calculus and cache-transfer style:** public Agda/Coq developments justify change transformations under specified language/primitive and cache-validity premises. They provide a route to deriving updates instead of handwriting every maintenance rule. They do not automatically preserve Core's partial expressions, checked overflow or ordered traces. [Project and formal artifacts](https://inc-lc.github.io/).
- **Certified graph-view maintenance:** VerDILog provides relevant Coq algorithms and support invariants, but its inspected theorem establishes program satisfaction, and its artifact flags extraction axioms and a theorem-strengthening gap. Do not equate that with exact full query equality or an end-to-end verified runtime. [Artifact caveat](https://raw.githubusercontent.com/VerDILog/VerDILog/iclp-2018/vup.v).
- **Verified executable certificate checking:** cake_lpr is a concrete model for an untrusted proof producer and verified checker implementation. It checks the supplied propositional problem, not an unverified encoding of Core. [Paper](https://cakeml.org/tacas21.pdf).

See [derived architectures and proof scope](derived-architectures.md) for source detail. No external artifact was built or its axioms independently audited here.

## 8. Where Nova belongs after the reduction

First specify who must establish which claim:

| Consumer requirement | Needed capability | Does it entail IVC? |
|---|---|---|
| Local correct execution | Sound maintained meaning/execution inside the accepted native boundary | No |
| Independent checking with retained inputs | A complete checker or replay from an accepted anchor | No |
| Independent long-history checking with bounded history-dependent verifier work | Succinct authenticated computation/provenance or a different explicitly trusted anchor | IVC/PCD is a serious candidate, not the only conceivable mechanism |
| Full reconstruction | Sufficient available input/state/history and an interpreter | A validity proof alone is insufficient |

Nova can accumulate proofs of the chosen interpreter or checker relation. It does not define that relation, prove the checker correct, eliminate its work or make data available. The existing [IVC research](../greenfield-redesign-20261028/ivc-findings.md) distinguishes proof steps from semantic transactions and step-size costs from history length. The verified/native result and cryptographic argument have different assumptions and deployment purposes.

Thus the investigation should not begin by requiring a hybrid. First define F, J, K and the consumer's claim. Then compare native execution, explicit certificates, checkpoints/replay and accumulated computation proofs against the same requirement. A hybrid is appropriate only if both incremental execution and succinct remote historical verification are needed and its costs/correspondence are justified.

## 9. What changes in the research order

The next bounded research object is a **minimal reference transition and maintained-meaning contract**, not a choice of tree or proof library.

Use one public model containing local positivity, a genuine cardinality limit, references and identity lifetimes. Include command-only events and contextual input that can change a result. Specify exact successful/denied/error observations and the information retained for reconstruction. Then:

1. Define Ω and F, including the history-derived information needed by the next request.
2. Define exact J equalities for count, incoming references and any reused rule result; define initialization and module-change/recovery boundaries.
3. For each architecture, provide its update/checker/translation theorem and correspondence scope before favorable performance claims.
4. Compare them with the same omitted-member, extra-member, reused-ID, stale-summary, overflow, lazy/first-error and duplicate-command cases. Include high-fanout updates and cold verification.
5. Measure necessary semantic work, maintained-state work, witness construction/checking, proof work, persistence, full export and recovery separately. Preserve unknown/unsupported cases through exact reference behavior.
6. Only then choose the representation and whether succinct accumulated proofs are required by the consumer profile.

This is an investigation sequence, not authorization to implement a new Core language, runtime framework or governance mechanism. Old hashes, receipts, semantics and evidence remain unchanged. The [obligations and limited counterexamples](obligations-and-limits.md) and [derived architecture research](derived-architectures.md) are the supporting primary-source notes.
