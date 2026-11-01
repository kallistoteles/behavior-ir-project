# Researched alternatives for a chained fast Core

Date: 2026-11-01. This follows the user's clarified requirement: startup, ordinary transitions and independent historical verification must all be correct and connected by one mathematical argument. A faster warm path that leaves startup/replay/proving expensive does not meet that requirement. “Two minutes” remains hypothetical. This review reads primary papers and pinned artifacts; it does not build artifacts, independently audit their axioms, measure performance or change sealed studies/production code.

## Start with the expensive work and ask why it exists

The retained Core observations identify concrete obligations and incidental work. Each row below asks whether a researched method can establish the same fact more cheaply. The proposed replacements are inferences requiring Core-specific correspondence, not results demonstrated for Core.

| Current costly work | Why the checking path performs it | Researched replacement to assess | Exact unresolved condition |
|---|---|---|---|
| Complete J/state rechecks before and after an ordinary update | The prototype does not trust a merely maintained count/reference/query view | A proved initialization plus exact incremental maintenance/change compilation | Translation and maintenance preserve the complete observation semantics, not just a safety predicate |
| Repeated query membership and absence enumeration | Supplied rows alone cannot establish complete results | Authenticated ordered indexes, range boundaries and authenticated aggregates, with proved maintenance | Every predicate/view used has complete coverage; index root corresponds to the authoritative state |
| Reconstructing every prior Core transition for a fresh consumer | Present Nova proof omits Core's exact identity/output bridge | Accumulate a relation that includes the same semantic and identity/observation claim | Correct initial anchor, complete step relation, checked encoding/identity bridge and expected endpoint |
| Repeated full record construction/parsing/hashing | Current event identity commits to expanded canonical evidence | A future versioned evidence contract with commitments to sufficient structured support/deltas | Reconstructibility and correspondence are specified and checked; retaining old expanded hashes still requires processing their exact bytes |
| Cold startup reconstructs all views and lifetime identities | A cold process lacks justified retained meaning | A verified initialization certificate plus authenticated persistent state/views, or proved direct construction | Imported state validity is actually established; missing required bytes still must be fetched |
| Parameter derivation/loading on fresh proof processes | Verifier/prover must use the intended circuit's parameters | Separate reusable parameters and circuit preprocessing from each proof; compare compressed verification | First deployment, loading, validation, circuit change and cold recovery remain charged to lifecycle cost |

Local primary evidence: [032 actual source-cost inventory, lines 7–19](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/evidence/source-costs.md:7), [full export and lifetime capture, lines 45–55](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/evidence/source-costs.md:45), [Core canonical identity/evidence floor, lines 114–122](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md:114), [actual Nova/cold lifecycle, lines 150–168](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/evidence/cost-model.md:150).

## Established machinery that can replace recomputation

**DBSP provides an actual verified transformation theory, not just an incremental-engine analogy.** The VLDB 2023 paper defines incrementalization as D∘Q∘I; Proposition 3.2 supplies composition laws and Algorithm 4.6 derives incremental query plans. It reports Lean verification. The pinned artifact contains `chain_incremental`, `I_push` and `incrementalize_ok`, with additive commutative-group assumptions and a soundness premise for recognizing linear primitives. This can support exact relational view maintenance after a justified translation. It does not prove Core's interpreter, SQL compiler or deployed runtime. The paper also explicitly retains full operator state for some operators and discusses expensive initialization when installing a new plan; “incremental” does not mean constant memory or free startup. [DBSP paper §§2–4, 8](https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf), [pinned mathematical identities](https://github.com/tchajed/database-stream-processing-theory/blob/fb6ff4416108710448ccd87473c5513c1a1179ea/src/incremental.lean#L89), [pinned transformation theorem and premises](https://github.com/tchajed/database-stream-processing-theory/blob/fb6ff4416108710448ccd87473c5513c1a1179ea/src/circuits.lean#L348).

**ILC is a second exact transformation route.** PLDI 2014 Theorem 3.11 relates evaluation after a valid change to applying the derived output change. Its Agda development exposes the theorem and primitive-plugin interface. Primitive correctness proofs and valid changes are premises; fast derivatives require deliberate primitive design rather than following automatically from differentiation. This is potentially useful beyond a relational sublanguage, but is not an already proved Core translation. [Author's PLDI 2014 paper §3.6–4](https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf), [pinned theorem inventory](https://github.com/inc-lc/ilc-agda/blob/39bb081c6f192bdb87bd58b4a89291686d2d7d03/PLDI14-List-of-Theorems.agda#L77).

**Cache-transfer style addresses retained intermediate computation explicitly.** The pinned Coq artifact's Theorem `_3_7` connects old/new base evaluations, initial/updated caches and the cache-transformed derivative; Lemma `_3_6_B_1` exposes the cache/environment premises. The theorem assumes a valid environment change and terminating old/new evaluations. It is not a universal resource bound or persistent-storage/recovery theorem. The artifact declares functional and propositional extensionality. [CTS theorem and premises](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/Overview.v#L95), [declared axioms](https://github.com/yurug/cts/blob/ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7/coqproof/README.md#L35).

For Core, these results suggest proving change laws once and executing derived programs thereafter, instead of proving view validity again by full co-evaluation at every step. That is the inference to investigate. Core032 explicitly deferred verified incremental compilation and sparse witnesses; its conservative A/B results do not measure this architecture. [032 planning choice, lines 5–13](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/research.md:5).

## Core's arithmetic and observation contract is a real translation obligation

DBSP's commutative groups and relational results do not automatically represent checked signed-64 arithmetic, lazy partial expressions, first-error selection or ordered observations. For example, evaluating an ordered checked fold can overflow at an intermediate addition even when its mathematical final sum fits. Reassociating to an exact group sum could erase that observable error. Likewise, evaluating a formerly skipped branch can introduce an error; comparing only final truth values misses this change. These are explanatory deductions about Core's required contract, not new executed counterexamples. Prior research already flags these precise correspondence gaps. [Core-specific change-algebra limits, lines 61–69](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/derived-architectures.md:61), [complete checker observations, lines 50–56](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md:50).

A suitable translation must represent sequence positions, error outcomes, laziness and occurrence multiplicity explicitly, prove an ordered/error-aware summary law, or prove that a particular optimization's domain is total and safe. A sound fallback preserves complete language behavior, but its frequency and cost count against the overall goal. Restricting a benchmark to easy expressions does not establish a fast complete Core.

## Established authentication can establish more than a naked hash

The SIGMOD 2006 authenticated-index paper distinguishes correctness, completeness and freshness. Its Merkle B-tree range-query protocol includes boundary neighbors and hashes needed to reconstruct the relevant authenticated subtree; checking membership of returned rows alone is not its completeness protocol. These techniques replace scanning unrelated data only for the supported ordered-query/index contract and an accepted exact root. An empty interval needs boundary/nonmembership justification too. Extending that construction to arbitrary Core predicates is a separate proof obligation. [Primary paper §§1, 3.2, 5](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf).

There is also specific research for authenticated aggregates: Li et al.'s accepted 2010 manuscript supplies static/dynamic index techniques for range-selected aggregate queries. Its construction starts from owner-endorsed data; it does not prove that arbitrary Core updates correctly preserve those endorsed aggregates. [Author-hosted manuscript §§2, 4–6](https://www.cs.bu.edu/~reyzin/papers/auth-db-agg.pdf). The Core inference is to prove an index's defining equality at initialization and each update inside the transition relation. That can make an opened exact count useful for verification; merely hashing an independently supplied count cannot.

For arbitrary global facts, there is no established shortcut in these sources that removes all possible affected work. A newly inserted row can change a previously empty query without changing any old result member. A reverse-reference absence claim concerns every possible incoming edge. The maintained meaning must cover both facts and the dependency/invalidation rule. [Core's explicit coverage requirement, lines 78–100](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md:78).

## Accumulation replaces repeated history verification only after the right relation exists

The pinned Nova README describes incremental proof extension with work independent of preceding step count. Its compression options include Spartan and preprocessing-based MicroSpartan; HyperKZG/Mercury introduce universal setup requirements. These are different lifecycle/assumption choices, not measured Core speedups. [Pinned upstream explanation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/README.md#L1).

Pinned source separately implements public-parameter setup, recursive proof extension, recursive verification and compressed-proof keys/proving/verification. Recursive verification takes expected initial input and step count and returns a final state; the application must check that returned state against its expected exact subject. Compression setup/proving are explicit additional operations. [Pinned implementation](https://github.com/microsoft/Nova/blob/01b1e2d662a847ed7029770ecbaf6687398899dd/src/nova/mod.rs).

Thus the practical alternative to replay is **accumulate the proof of a complete incremental checker**, including authenticated state/index accesses and the precise Core identity/observation bridge. A proof of its transition relation is useful only after that relation is proved to implement Core. Initial memory, imported summaries and checkpoint validity must be established; RAM/read consistency or a fixed final root alone does not establish them. This is a composition proposal, not a theorem supplied by Nova. [Previously specified Core composition obligations, lines 48–78](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md:48).

Actual Core032 Nova C1/H2 first-use whole median is 68.818 s versus 22.487 s for separately measured parameter-artifact reuse; reuse still spends approximately 9.6 s per process loading/decoding/validating. Compression was not implemented. A resident process and compressed verifier are legitimate unmeasured comparators; their preparation/recovery costs must remain visible. [Actual measured scopes, lines 150–157](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/evidence/cost-model.md:150). The full replay bridge means the experiment does not yet implement the proposed historical shortcut.

Proof validity and data audit answer different questions. A proof can certify a transition prefix while historical support later becomes unavailable/corrupt. Full historical data auditing or exporting requested bytes still requires obtaining and checking those bytes. A new verifier may establish semantic history validity succinctly; it must not silently claim it also inspected every retained object. [Existing exact distinction, lines 80–86](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md:80).

## The required mathematical chain

The proposed common relation should bind operational state Ω, retained semantic views V, exact module/profile/context, lifetime identity inventory, state/index roots, exact history head and the ordered observation/command commitment. Let J(Ω,V) mean that every view equals its declared semantic function. The following are new design obligations:

1. **Initialization:** an accepted initialization claim establishes valid Ω₀, J(Ω₀,V₀), correct commitment encodings and exact initial history. Proving only a hash of an import is insufficient. A valid existing certificate can justify its root, but a process that needs imported data must still retrieve/authenticate it.
2. **Transition:** under those exact premises, accepted R produces the exact Core decision/errors/effects/observations, preserves J and updates every state/history/index/output commitment correctly.
3. **History:** proof soundness plus the same R and initialization claim establishes the exact prefix by induction; the independent consumer checks the expected module, anchor, logical position and final observation/state subject.
4. **Continuation/recovery:** opening the committed roots supplies data with the meaning used in R. Rebuilding or restoring views/proof state reestablishes the same J before reuse. Module changes and migrations require explicit boundary theorems.
5. **Availability/audit:** sufficient retained inputs and support reproduce the promised views and outputs; missing support is reported separately. Physical command delivery and external authority still require their stated host/source contracts.

Then the desired theorem is conditional existence of the exact Core-valid history **and** correctness of the state used to continue it. It is stronger than separately proving “a count is safe,” “a Merkle path verifies” and “a Nova proof verifies.” No examined source provides this Core theorem already. Its shape follows the existing complete Core contract, which distinguishes all these premises. [Core theorem proposal, lines 58–70](/tmp/behavior-ir-core-final-20261031/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/composition-findings.md:58), [032 common requirements, lines 96–116](/tmp/behavior-ir-core-final-20261031/specs/032-transition-verification-study/spec.md:96).

## Account for every phase, then decide whether work was removed

The candidate to assess is a proved/validated incremental compiler or view algebra, authenticated semantic state/index maintenance, and accumulated proof of that exact transition/initialization relation. It is an established-method composition hypothesis rather than a newly invented primitive.

Its comparison must retain four concrete scenarios: first initialization from authoritative data; cold restart/continuation from a certified persisted state; ordinary transition through the exact externally verified endpoint; and fresh independent historical verification, plus required data audit/export. Charge compilation, index construction, witness generation, hashing, parameter preparation/loading/validation, proof production/compression/verification, durable publication, support transfer and rebuilding to their actual scenario. Show cumulative work across a declared lifecycle as well as each latency.

Keeping parameters/views warm may amortize cost legitimately; claiming success requires showing cold cost, reuse lifetime, memory and rebuild failures. Proving asynchronously changes when verification completes; it does not remove proof work, final verification latency or growing backlog. If all three phases are required, measuring only a native commit or an interior fold is insufficient. Requiring all retained data to be audited remains more expensive than verifying only semantic prefix validity, so both findings must be measured under the promised contract.

There is no source-backed millisecond guarantee for arbitrary Core programs, initialization sizes and history-verification contracts. There is a concrete researched path to removing repeated work: exact differential programs, complete authenticated queries and accumulation of the right relation. The remaining question is whether their composed Core implementation removes enough total work across **all three** phases while preserving the same meaning.

## Primary versions inspected

Repository heads were independently resolved by the GitHub commits API on 2026-11-01; citations above use immutable revisions. No source artifact was executed.

| Artifact | Inspected version |
|---|---|
| DBSP Lean theory | `tchajed/database-stream-processing-theory@fb6ff4416108710448ccd87473c5513c1a1179ea`, commit date 2023-08-22 |
| ILC Agda | `inc-lc/ilc-agda@39bb081c6f192bdb87bd58b4a89291686d2d7d03`, commit date 2018-04-06 |
| CTS Coq | `yurug/cts@ae1bf7b4b7ef82167324c7ce18dc3785b7dcaab7`, commit date 2019-02-19 |
| Nova | `microsoft/Nova@01b1e2d662a847ed7029770ecbaf6687398899dd`, commit date 2026-09-11; matches the Core032 pinned upstream revision |

Downloaded PDF bytes were hashed in memory; no PDF archive or build was added:

| Source | Bytes | SHA-256 |
|---|---:|---|
| DBSP VLDB 16(7), 2023, pp.1601–1614 | 748701 | `48ea73d2d5d098b0ae97f59f818789f5408a503e17062a6041c5f2e4cf9c78be` |
| ILC PLDI 2014 author manuscript | 444511 | `4b9637310e0de0157d6cdc029c2e60cb1c7b3e5bf6270e3cf70e04b41669b7b9` |
| SIGMOD 2006 dynamic authenticated indexes | 284476 | `27cebf504db7bde067efe9b73ec762d6e23cc5938d3713d40e51ac26dd5396e7` |
| Authenticated aggregate manuscript, accepted February 2010 | 421778 | `f487e0185da421ec3ffea5ddca4194b289daefeef075441088e37ef2c7c237d9` |

The CTS PDF was retrievable as 686786 bytes, SHA-256 `9cc4e12ad24114ee350b9f7e5c8d279f85f147ea0bd65bbc0fa4621e57012db0`, but the browser could not parse its octet-stream content. Claims here instead follow the inspected pinned Coq statements and declared assumptions. The author-reported paper proofs and inspected declarations remain distinct from independent kernel checking or a verified Core implementation.

