# Execution evidence: obligations and limits from first principles

Research date: 2026-10-28. Core baseline: `fc73fa36b959aeaf54cff2f38dd190c4389c3fa1`. This note does not select an architecture. It distinguishes source-backed concepts, our deductions and finite examples, and existing local evidence. No new implementation, tests, proofs, dependency installation or proof builds were performed. Earlier notes and uncommitted work remain unchanged.

## 1. Separate the claims before choosing their representation

[Lamport, *Specifying Systems*](https://lamport.azurewebsites.net/tla/book-02-08-08.pdf), §§5.7–5.8, distinguishes invariance from implementation under a refinement mapping: an invariant holds in all reachable states, while implementation relates the behavior of one specification to another. These are mathematical specification/proof techniques, not evidence that Core already satisfies a new correspondence theorem.

For this investigation, the following are separate proposed questions:

| Claim | Question the evidence must answer |
|---|---|
| Transition semantics | Did this exact request, under these semantics and inputs, produce this state change and these observations? |
| Invariant preservation | Does the chosen property hold before/after each applicable transition? |
| Provenance | Which inputs, sources and prior events account for this result? |
| Authorization | Were those sources/principals permitted to authorize this operation under the applicable policy/context? |
| Historical identity | Which ordered event occurrence and lineage does the claim concern? |
| Availability/reconstruction | Can the required consumer obtain enough data to reproduce the requested object or observation? |

**Our finite example:** from integer state `x=0`, the requested operation `increment` should yield `x=1`. A producer returns `x=2`. Both preserve `x>=0`; invariant preservation alone misses the wrong transition. Conversely, a faithful execution may return a specified denial/error. Correct execution is not synonymous with permission or a successful state update. No external impossibility theorem is being asserted by this example.

## 2. Exact execution requires an explicit input and observation boundary

[Schneider's state-machine account](https://www.cs.cornell.edu/fbs/publications/SMSurvey.pdf), §§1–3, models commands as deterministic atomic programs, requests containing necessary information, and replica coordination as agreement on requests and their order. Determinism there is a modeling premise. It does not establish that an arbitrary real program is deterministic or that a particular event format records every input.

**Our deduction:** write the intended step as a function/relation over explicit state, admitted semantics, request, contextual inputs and external observations. Specify its outputs: decision, errors, state changes, command intents and any normative evaluation trace. Clock readings, randomness, authorization evidence, remote responses, module versions or ordering choices that can change those outputs must be fixed by the input or otherwise accounted for. A proof of a different function does not answer this question, however small or fast its verifier.

**Our finite example:** a command emits `approve` when an externally supplied bit is `1`, otherwise `deny`, and leaves state unchanged. Two runs have identical final state but different command streams. Recording only final state cannot reconstruct both streams. Recording the input bit, the resulting command, or sufficient equivalent information could; which is required depends on whether the consumer wants state replay, execution re-evaluation or provenance audit.

The local [complete-observation contract](../../contracts/correctness.md) names phases, errors/order, traces, typed reads, changes, command occurrences, state and exact history. That is an existing project requirement. It is not an external theorem or a newly executed validation result.

## 3. Minimum retention is relative to what must be reconstructed

**Our deduction, not a general compression lower bound:** a retained representation is sufficient for a reconstruction target only if histories that it treats identically do not require different reconstructed answers. The preceding two-run example fails this criterion for commands. It need not fail for current-state reconstruction. There is no single minimum log format independent of the target, initial knowledge, permitted retrieval, compression model and trust assumptions.

A deterministic replay contract therefore needs an accepted initial state or checkpoint; recoverable ordered events/inputs sufficient for its replay function; the relevant semantics/schema/module versions and migration interpretation; and a rule for resolving referenced data. Values may be compressed, deduplicated, derived or retained elsewhere. A reference is sufficient only under an explicit retrieval/reconstruction contract. Replacing a prefix with a checkpoint changes what can be reconstructed from that export unless adequate prefix support remains available.

**Our finite example:** histories `[send(A)]` and `[send(A), send(A)]` can have the same business state. A set of command values loses occurrence multiplicity. An ordered occurrence list preserves it. A commitment can distinguish histories without itself being an executable recipe for recovering their contents; one must specify the actual retrieval/decoding mechanism rather than infer it from integrity.

This also separates retry identity from equality of business state. Whether an uncertain command committed is a question about an event occurrence. External delivery and acknowledgement constitute additional events beyond a pure business-state transition.

## 4. Cryptographic provenance does not establish the original world's truth

[Lampson, Abadi, Burrows and Wobber](https://bwlampson.site/45-AuthenticationTheoryAndPractice/Acrobat.pdf) formalize principals, channels, delegation and a “speaks for” relation. Authentication/authority reasoning starts from assumptions connecting channels and principals; it does not create those connections without premises. [Proof-Carrying Data](https://projects.csail.mit.edu/pcd/) instead attaches proofs that data and its computational history comply with a specified predicate. The original construction uses a signature-card model; it is not an assumption-free provenance mechanism.

**Our deduction:** a proof may establish “this input was signed by key K and processed according to rule R.” To establish an authorized observation, the contract must additionally bind K to the accepted source and its authority at the relevant event. Even then it does not establish that a sensor measured reality correctly unless that assertion is among the trusted premises. A valid computation proof cannot manufacture a missing original external response. If a private witness contains it, existence of that witness does not by itself make its bytes available to a later auditor.

**Our finite example:** a temperature source signs `20`; another signs `80`. The same computation approves the first and rejects the second. Faithful proofs for both say nothing about which source was authorized, which observation actually arrived, or the physical temperature without further bindings. Checking one supplied policy's signature also does not establish that every applicable policy was selected.

## 5. Query correctness needs coverage, including absence

[Li et al., *Dynamic Authenticated Index Structures*](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf), introduction and §3, explicitly separate correctness, completeness and freshness. Their range-query constructions authenticate boundaries and intervening records, rather than merely authenticate each returned row. The scope is particular ordered query structures and their update protocols, not all predicates or all reference invariants.

**Our finite example:** the authoritative set is `{a,b,c}`, all satisfying a query. A response `{a,b}` with valid individual membership evidence still omits `c`. Likewise, an empty response cannot be justified merely because it contains no invalid member. Nonmembership at one key, completeness of an ordered range, and completeness of an arbitrary predicate are distinct claims.

Dependencies include facts about what is absent. A previously empty query changes when a matching entity is inserted, although none of its old result members changed. A “no incoming reference” result changes when a new holder references the target. Tracking only fields read from returned entities misses these changes. An index can help if its relation to the complete authoritative collection and its update rules are established; authenticating a producer-selected partial index only protects that partial index.

## 6. Cold checking and maintained summaries have different premises

**Our finite black-box example:** a deterministic checker is given four unknown bits and must decide whether all are zero. After reading only the first three zeros, inputs `0000` and `0001` are indistinguishable in its observations but require different answers. This illustrates a missing-information obligation in that exact access model. It is not a lower bound for verifiers equipped with authenticated summaries, preprocessing, certificates, randomness or stronger access primitives.

[Patnaik and Immerman's dynamic-complexity model](https://people.cs.umass.edu/~immerman/pub/dynfo.pdf), definition of `Dyn-C` and the parity example, explicitly separates the initial data structure from update functions and the maintained query. It offers a formal framework for studying auxiliary information and updates. Its complexity results concern that model and specified query classes; they do not prove cryptographic authentication, sequential wall-clock bounds or Core correspondence.

**Our deduction:** a maintained zero-count could answer the four-bit question cheaply after initialization. Its usefulness depends on a correct initial count and updates covering every bit change. A signed or hashed count of zero without that semantic connection is insufficient. Initialization, incremental maintenance and cold verification must therefore be costed and justified separately. “The producer already knows the answer” and “the consumer has established the answer” are different premises.

## 7. One write need not mean one affected obligation

**Our finite examples:** three entities each require `entity.amount <= global.limit`. Changing only `global.limit` can change all three results. Changing one edge can alter reachability for many pairs. These show global dependency, not an unavoidable scan cost: a maintained maximum, specialized reachability representation or other valid summary may avoid revisiting every obligation for some queries.

The work bound depends on the predicate language, allowed updates, summary space and initialization, observations requested, and the verifier's trust/access model. If the required output explicitly lists every changed entity's trace, output production itself grows with that list. If the target is only a decision, a different sufficient representation may exist. No unconditional assertion that arbitrary Core execution must scan the full state follows from these examples.

## 8. Availability is a separate protocol property

[Juels and Kaliski's proofs of retrievability](https://www.arijuels.com/wp-content/uploads/2013/09/JK07.pdf), §§2–3, define a distinct extraction/recovery interface and security experiment for an encoded file. Their model restricts the adversarial response behavior used for extraction; its guarantee must not be paraphrased as permanent network availability. This illustrates why recovery is separately specified rather than inferred from a digest or computation-validity proof.

**Our deduction:** retaining a proof that a transition was valid does not require a prover to keep serving every underlying object indefinitely. Conversely, available bytes may be invalid. Consumer results should distinguish a semantic mismatch from missing support, incompatible semantics and resource exhaustion. A replay/export obligation needs retention, retrieval, versioning and missing-data behavior, even when normal verification uses a compact certificate.

## Research directions derived from these obligations

The next comparisons should remain open: identify the minimum observation target for each consumer; classify predicates by dependency and maintainable-summary structure; compare cold replay, validated checkpoints, authenticated query witnesses and computation proofs under the same explicit assumptions; account separately for initialization, steady updates, proof production, export and recovery; and trace external-input authority to its accepted boundary. For each option, ask which claim becomes independently established, which premise remains trusted, and which bytes remain reconstructible. These questions can eliminate insufficient designs before selecting a storage layout, incremental engine or proof system.
