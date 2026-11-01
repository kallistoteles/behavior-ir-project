# Architectures derived from deterministic execution and independent checking

**Date:** 2026-10-28. **Core baseline:** `fc73fa36b959aeaf54cff2f38dd190c4389c3fa1`. Primary-source research only: no code, dependency changes, installations, proof builds or benchmarks. Reported formal results belong to their source languages and artifacts; none has been independently replayed here or establishes a theorem about Core.

## Start with the claim and the consumer

The requirements imply an exact transition function and a way to reproduce its audit data. They do not initially imply recursive cryptography, a content-addressed object graph, or a particular incremental engine.

Write the operational input as `X = (live entities, lifetime-used identities, exact history, module/schema/profile)`, plus request and context. Let `F(X, request, context)` return the exact decision, resulting operational state, ordered commands and required observations. Equality of live-state content is insufficient: history and identities that were used and removed can change the next legal transition. The [persistence contract](../../../../docs/persistence.md) also requires typed errors, lazy evaluation, first-failure order, reference integrity, duplicate command occurrences and historical-profile replay.

A derived view `V` can contain indexes, counts, retained validity and intermediate rule values. The crucial invariant is `J(X,V)`: every retained component has its specified meaning for this exact operational input. “This value is hashed” is weaker than `J`; “all supplied rows passed” is weaker than complete coverage.

Three deployment requirements must be distinguished:

| Consumer | Minimum justified architecture | Additional cost/trust decision |
|---|---|---|
| All-local engine and storage within one trusted process boundary | Correct incremental evaluator with checked ingress and a preserved `J` | Private typed certificates may suffice; cryptography is optional. Persistent/cross-process caches need renewed validation. |
| Independent consumer willing to process retained inputs/certificates | Separate deterministic checker with complete inputs, or replay of the reference semantics | Producer optimizations can be untrusted. Fresh verification still processes initialization and an appropriate continuation; compact per-step certificates do not automatically compress history. |
| Remote consumer requiring succinct verification of long history | Cryptographic execution/accumulation argument for a specified interpreter or checker | Adds cryptographic assumptions, producer work and public-statement binding. It does not provide missing audit data or prove a flawed checker sound. |

This allows three specific architectures to be investigated on their own merits.

## 1. Maintain an inductive semantic state

For recurring rules, maintain exact auxiliary views as part of the execution machine: reverse references, query membership, count/sum summaries and per-obligation outcomes. Establish `J(X0,V0)` at initialization. Prove that an admissible update and its maintenance algorithm preserve `J(X,V)`, then derive the decision from the maintained values. This can avoid producing a new general proof object on every ordinary local transition: the verified update algorithm and its initialization invariant justify reuse.

**Formal precedent.** [Certified Graph View Maintenance with Regular Datalog](https://arxiv.org/pdf/1804.10565) supplies Coq definitions, incremental delta-join maintenance and a soundness theorem for a bounded graph-query language. Its state includes valid support, processed strata and pending strata, so reuse has explicit premises. The formal theorem establishes satisfaction of the program under listed preconditions; it is not automatically the equality of an exact least query result. [The public artifact](https://github.com/VerDILog/VerDILog) exists, but its [source header](https://raw.githubusercontent.com/VerDILog/VerDILog/iclp-2018/vup.v) explicitly warns that extraction uses axioms for efficient OCaml maps/sets and that the main theorem should be strengthened. This is a useful algorithm/proof structure, not an end-to-end verified exact-view runtime to adopt unchanged.

**Core application, inferred:** separate base operational data from maintained views and state every view's defining equality. For example, a count view equals the cardinality of the authoritative selected set; a reverse-reference view equals all incoming edges, not a producer-chosen subset. Initialize those equalities once, preserve them for each complete delta and bind them to exact module/profile and history. A module change can invalidate the view definitions and require rebuilding.

Rule satisfaction alone is insufficient for exact query results. Extra members can change counts or selected errors; missing members can hide violations. A suitable theorem must exclude both. Likewise, preserving a state invariant does not prove that the particular decision, commands and observations equal `F`.

This model has the clearest value when rules are expressible through a small exact view algebra. It loses its hoped-for locality when a tiny mutation changes many dependencies. The cost variable is affected semantic work, not changed-cell count. An independent consumer can execute the same verified maintenance code from a checked initial state; it need not trust a native certificate supplied by the producer.

## 2. Let an untrusted executor produce a checkable transition witness

Instead of verifying the entire optimizer, verify a checker `K`:

`J(X,V) and K(X,V,request,context,result,witness)=accept`

`implies result=F(X,request,context) and J(X',V')`.

The producer can choose indexes, scheduling, parallelism, caching or specialization. The checker accepts only derivations allowed by a fixed semantic calculus. Witness rejection is not a semantic DENY: an incomplete validator must fall back to reference evaluation or request another valid derivation, preserving the original public result.

**Formal precedent.** CompCert's [register-allocation validator](https://compcert.org/doc/html/compcert.backend.Allocation.html) checks output from an external allocator. Structural checking relates source instructions to target blocks; dataflow equations establish preservation of values. [Rideau and Leroy's paper](https://xavierleroy.org/publi/validation-regalloc.pdf) reports a mechanically proved Coq soundness result and explains the tradeoff: a verified validator can give the same accepted-translation guarantee while rejecting some valid transformations. This validates a compiler pass, not arbitrary Core executions. The reusable idea is a domain-specific, proved acceptance relation rather than proving the search strategy.

**Core application, inferred:** witnesses can say “evaluate this obligation”, “reuse this exact old result under these unchanged dependencies”, or “update this exact summary by this complete delta”. The checker independently establishes the premises. It must account for every required obligation: an explicit canonical obligation schedule, a proved complete affected partition, or a static coverage theorem can do that. An arbitrary list of successful checks cannot.

Skipped/lazy obligations need exact branch justification. Negative facts such as absence and unchanged query membership need explicit coverage. Checked arithmetic and selected failures must be represented in the calculus rather than replaced by mathematical integers or unordered conjunctions. Ordered command occurrences belong in its conclusion.

This architecture can be useful without cryptography. A consumer with the exact parent state runs `K` on a transition witness. If database access crosses a hostile boundary, authenticate the inputs separately. If the consumer later needs succinct history verification, prove executions of `K`; that is an optional deployment layer, not a reason to define `K` poorly.

**An actual checker component.** [cake_lpr](https://cakeml.org/tacas21.pdf) verifies hinted propositional unsatisfiability certificates with a machine-code correctness story through CakeML, including modeled parsing/I/O assumptions. Its [public artifact](https://github.com/tanyongkiam/cake_lpr) contains generated assembly and identifies HOL/CakeML revisions. It is evidence that untrusted proof production plus a verified executable checker is practical. It could discharge a carefully encoded bounded sub-obligation; it does not verify the encoding from Core, exact scheduling, or query completeness. A SAT proof over an incomplete formula proves the wrong claim perfectly. There is no present case for routing all Core execution through SAT.

## 3. Compile rules into correct incremental programs

If recurring semantic computations have structure, derive their change programs rather than discovering dependencies anew at runtime. For a pure computation `f`, seek the equation:

`f(x ⊕ dx) = f(x) ⊕ df(x,dx)`.

With retained intermediates, an initialization returns `(y,c)` and the update returns `(dy,c')`; the invariant says `(y ⊕ dy,c')` equals fresh execution at `x ⊕ dx`. The cache is semantic state with a validity relation, not a bag of trusted memoized answers.

**Formal precedent.** [A Theory of Changes for Higher-Order Languages](https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf) proves static differentiation for a family of simply typed calculi in Agda, parameterized by base-type/primitives interfaces. The [Agda artifact](https://github.com/inc-lc/ilc-agda) is public. Correct derivatives for domain primitives remain obligations; efficient derivatives are not automatic consequences of the generic theorem.

[Cache-Transfer Style, ESOP 2019](https://link.springer.com/chapter/10.1007/978-3-030-17184-1_20) explicitly retains intermediate results and updates caches, using Coq simulation/logical-relation proofs for an untyped calculus. Its [theorem overview](https://raw.githubusercontent.com/yurug/cts/master/coqproof/Overview.v) relates old/new terminating executions, a valid environment change and transformed cache/update executions. The [artifact's assumptions](https://raw.githubusercontent.com/yurug/cts/master/coqproof/README.md) list functional and propositional extensionality. This is a formal transformation result, not verification of the case-study host runtime or Core's language.

**Core application, inferred:** compile an eligible rule fragment to an exact typed view/change algebra and derive maintenance code. Prove the translation once for the fragment, then prove its primitive change laws. Alternatively validate each compiled module against the source semantics. This can amortize proof effort across many actions and module instances without generating a new cryptographic execution proof per action.

The correspondence must cover the full observable result. Mathematical sums over bags do not preserve checked signed-64 intermediate overflow automatically. Unordered set semantics does not preserve lazy traversal, first error or trace order. One option is an explicitly ordered/error-aware primitive algebra; another is to certify summaries only for a total, proven-safe fragment and use reference execution elsewhere. Neither option licenses changing existing semantics.

[Q*cert](https://github.com/querycert/qcert) is a concrete supplementary reference for typed data-language IRs and semantics-preserving query compilation; its maintainers carefully claim mechanical verification of a **significant subset** of the pipeline. It is not an incremental engine or a fully verified frontend/runtime for every supported target. A bounded exact-query translation can borrow its definitions or proofs after checking the relevant path, rather than inventing a general new query language.

## What each model proves, and what remains

| Model | Reusable formal material | Core-specific gap | Suitable first discriminator |
|---|---|---|---|
| Inductive maintained state | Finite-map/view update laws; support/stratum invariants; delta joins | Exact view equality, initialization, full operational-state correspondence | Preserve an exact reverse-reference/count view across create/delete/recreate, then compare full results. |
| Witness checker | Structural coverage plus checked semantic equations; executable certificate-checker patterns | Sound acceptance calculus for all selected Core observations | Change the producer strategy without changing `K`; malformed omissions must fail, valid fallback must agree. |
| Incremental compilation | Verified derivative/cache transformations and primitive interfaces | Translation, checked errors/order, maintained-cache validity | Derive one total rule fragment and compare its updated value/cache with fresh execution across changes. |

These are alternatives at different seams, not an instruction to combine all three. A maintained-view engine might already meet the all-local requirement. A witness checker may be preferable where producer implementations vary. Static derivation may fit predictable rule families better than a general dependency graph. An evidence representation can be ordinary typed data, a journal, shared objects or a streaming encoding; that choice follows the access and retention requirements.

If remote succinct verification is required, the macro-choice remains **prove the specified interpreter** versus **prove the specified witness checker**. The former can simplify the semantic statement while retaining full execution costs. The latter can exploit preservation facts, but requires a sound checker theorem first. IVC then compresses the history of the chosen relation; it does not replace its correctness argument. Neither route guarantees audit-input availability.

## A bounded next research step

Specify one common observable result including errors, observations and command multiplicity. Use an example with a local positivity rule, count limit and a reference whose incoming edges change after creation/removal. Include lifetime identity and exact-history changes. Write the reference transition and required `J` equalities before choosing a producer or evidence encoding.

For each candidate, state initialization, maintenance/checker/translation theorem and fallback scope. Try the same counterexamples: omitted dependent row; extra query member; stale reference index; same live state at different history; reused removed identity; overflow; altered first error; omitted duplicate command. Check both acceptance soundness and operational completeness through fallback.

Only then compare newly computed work, changed auxiliary state, witness bytes, independent-checker work, initialization and recovery. Include a high-fanout update so that every design confronts the distinction between small input change and large affected result. These measurements would choose among architectures; they should not start by presuming that a particular hybrid is necessary.
