# Greenfield Core: incremental evidence and accumulated computation proofs

**Research date:** 2026-10-28. **Core source baseline:** `fc73fa36b959aeaf54cff2f38dd190c4389c3fa1`. **Status:** architectural research; no redesign, proof backend, library dependency, benchmark or implementation has been approved or introduced. External theorems and experiments are primary-source findings, not independently reproduced Core evidence.

## Revised conclusion

There are two distinct scaling problems, and the previous recommendation treated their connection too lightly:

- **A — Incremental typed execution and shared evidence** can reduce repeated current-step work and storage. It does not, on its own, give a fresh independent verifier a succinct guarantee for an arbitrarily long history. A new object graph also does not establish that omitted dependencies are irrelevant.
- **B — Accumulated cryptographic verification, such as Nova** can avoid verification proportional to the number of accumulated steps for its specified computation. It does not make that computation inexpensive. Proving a full-state scan, large canonical JSON construction or unchecked summary faithfully still incurs that work or proves an insufficient claim.

The strongest architectural hypothesis is therefore **a hybrid whose proved step is a semantically complete incremental transition/checker**, with shared state/evidence and explicit data availability. It is not yet the selected solution. Compare it against compact native evidence without IVC and proof execution of a broader interpreter/guest. No source establishes the whole hybrid for Core, and no local performance experiment of the hybrid has run.

Nova belongs in the greenfield comparison from the outset. “Defer Nova because duplicate parsing can be fixed first” remains a reasonable short-term engineering boundary; it is not an adequate answer to the greenfield design question. This report supersedes that architectural prioritization in the [earlier options report](../architecture-options-20261028/architecture-options.md), without rewriting its historical findings.

## 1. Frozen observations versus new hypotheses

The [single-create profile](../single-create-20261028/report.md) measures 4,085,191 decision bytes at 8,192 parent entities, roughly 79% trace. Uninstrumented median evaluate/commit are 277/1,658 ms. Current predicates already reuse checked state: only three are evaluated in each phase. Repeated record interpretation, owned trees, canonical serialization and hashing remain substantial. These observations show representation work, not that a particular proof design is fast.

The [history series](../../evidence/history-costs.md) independently varies prepared H=8/32/128 at a fixed live population and fixed eight-event requested interval. A roughly 1.6-KB page takes about 1.97/3.35/9.65 seconds; scoped record reads are 78/174/558. Eliminating repeated trace construction does not, by itself, establish a replacement for these prefix-validation obligations.

Separate at least:

| Dimension | Symbol | Meaning |
|---|---|---|
| Live authoritative state | N | Entities and values, independently of history |
| Committed history | H | Logical published events, including command-only events |
| Affected dependencies | D | Actual semantic effects, query/index changes and invalidated checks; not just written cells |
| Expanded audit output | B | Bytes explicitly requested by an old/full audit view |
| Encoded step size | C | Constraints or guest execution needed for the specific step/checker |
| Proof steps | K | IVC folds, VM instructions or chunks; not necessarily equal to H |
| Persistent/working memory | M | Includes auxiliary indexes, summaries and proving state |
| New data | J | Newly materialized/stored/transferred distinct objects and witnesses |

A redesigned eligible local update may avoid work over unchanged N. A succinct prefix proof may avoid verification over H. Neither claim bounds D, C, M, J, initialization or export. Emitting B requested bytes still requires at least proportional output work.

## 2. Compare complete architectures, not isolated primitives

| Architecture | Potentially improves | Still unresolved or inherently required |
|---|---|---|
| **A0: current-format typed-object cleanup** | Duplicate decode/clone and local serialization constants | Canonical full-record bytes still grow with state; no independent history shortcut |
| **A1: compact native evidence + shared authenticated objects** | Incremental construction/storage, normalized traces, reuse and bounded access for eligible operations | A fresh verifier still needs complete derivation/replay or a justified anchor; cache lifecycle, query completeness and old corruption observations remain |
| **B1: IVC over a broad reference interpreter/guest** | Independent proof of the specified execution/history, broader language coverage than handwritten fragments | Full-state work inside the interpreter, memory/bootstrap, cryptography, proof production and code-to-Core correspondence |
| **C1: IVC over a proved semantic witness checker** | Potentially incremental producer/checker plus succinct prefix verification | Sound and sufficiently complete checker, complete dependencies, authenticated summaries, initial validity, relation/implementation bridge |
| **C2: incremental VM/RAM proving** | Avoid monolithic/worst-instruction circuit costs while proving memory accesses and variable instruction use | Consistent memory is not correct initial memory or complete query/rule coverage; epoch costs, artifact maturity and Core integration must be established |

C1 and C2 can be combined. C2 is not automatically a more correct implementation of C1. An ordinary compact receipt can authenticate an event without proving execution, and is not equivalent to B1/C1.

## 3. New source findings that change the comparison

### Authentikit: local authenticated reuse is not persistent history certification

The paper reports Rocq/Iris proofs for authenticated computation and reuse of proof data/decoded values. The pinned basic stateful verifier explicitly empties its cache at `run`. This directly supports reuse inside an independently checked computation, not automatic inheritance of a persistent cache across histories or recovery. Compiled-language correspondence and benchmark serialization have additional trust limits. [Paper](https://iris-project.org/pdfs/2025-ccs-veriauth.pdf), [pinned cache implementation](https://github.com/jtassarotti/veri-auth/blob/24c41ec37e5f12f75a40b00c65b787dea63810b0/src/basic/verifier_buf_magic_state.ml).

**Consequence for Core:** a verifier-owned checked-value cache and a semantic-result certificate require different invariants. Reusing a hash-authenticated value does not establish that the correct constraint set was evaluated. Cache persistence, schema/module context and invalidation need their own proof. [Detailed source review and composition contract](composition-findings.md).

### Nova: independence from history is not independence from the step relation

The original construction distinguishes accumulated IVC evidence from succinct compression. Proof/verifier costs depend on the step computation and chosen compression/commitment scheme. The public implementation additionally offers preprocessing and setup-dependent variants. Its concrete two-curve construction has a separate security analysis and historical correction. [Nova](https://eprint.iacr.org/2021/370), [two-curve analysis](https://eprint.iacr.org/2023/969), [implementation](https://github.com/microsoft/Nova).

**Consequence for Core:** explicitly count K and C. If one semantic create needs many proof microsteps, constant recursion overhead per microstep does not make the create constant-cost. A public endpoint proof must bind the logical H, exact event chain, module/profile, requests/context and outputs; a fold count alone is insufficient. Compression/preprocessing and final verification belong in the cost model, even if not run at every event.

### Nebula: RAM and heterogeneous instructions are part of the problem

The current paper, revised 2026-05-18 and published at IEEE S&P 2026, presents commitment-carrying IVC, read-write-memory machinery and a universal instruction switchboard to avoid paying for unused instruction circuits. It therefore addresses integration gaps that plain fixed-step Nova leaves open. Its reported EVM prototype comparison is not a Core benchmark. [Nebula](https://eprint.iacr.org/2024/1605).

**Consequence for Core:** include incremental authenticated memory/variable instruction designs in C2. Establish initial memory, continuation, proof-closing and epoch costs; do not assume that a memory argument proves whole-world completeness, correct auxiliary indexes, or bounded work per semantic transaction. Artifact availability and exact revision-specific memory obligations are selection gates. See [IVC source findings](ivc-findings.md).

A closely targeted alternative is [Volatile and Persistent Memory for zkSNARKs via Algebraic Interactive Proofs](https://eprint.iacr.org/2024/979), published at IEEE S&P 2025 and revised 2026-09-18. It explicitly treats committed persistent and sparse persistent memory rather than assuming only zero-initialized RAM. Compare its boundary/access model with Merkle paths and Nebula; its published improvements are not Core measurements or an automatically compatible Nova implementation.

### Verifiable state access has a concrete precedent

Pantry composes verifiable computation with content-addressed storage, checking state accesses inside the computation and requiring a bootstrapped initial digest. It separates proving execution from proving that the program expresses the intended semantics. Its older construction and measured overheads are not a performance prescription for Core. [Pantry, SOSP 2013](https://www.pepper-project.org/pantry-sosp13.pdf).

**Consequence for Core:** attaching an object-graph verifier beside Nova is insufficient unless their claims compose. The proved computation must verify the relevant authenticated access, or consume a separately checked result with an explicit sound binding. Shared hashes alone do not supply that bridge.

### A compiled guest is a comparator, not an automatic shortcut

A zkVM can prove a pinned program image and public outputs. For example RISC Zero documents segmented receipts and proof composition. Host/backend reads still need to be authenticated in the guest; proof execution of a compiler-produced binary does not establish its intended Core meaning. [RISC Zero proof-system overview](https://dev.risczero.com/proof-system/).

Magnetar is a fresh RV64 proving candidate, with publisher measurements and bit-oriented hashing machinery. However its October 5, 2026 paper explicitly says its proposed long-execution scaling paths were not implemented; recursion-friendly verification must not be reported as a measured accumulated-history deployment. Keep it as a conditional compiled-guest comparator, not a ready-made substitute for IVC. [Primary paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2026/10/magnetar-1.pdf).

## 4. The mathematical composition obligation

This section is a proposed contract to investigate, not an already discharged theorem.

Let `Z_i` identify the exact Store lineage/history position/event commitment, authoritative state commitment, module/schema/semantic/checker identity, and any authenticated materializations used as premises. Let `w_i` be an untrusted witness containing request/context, relevant authenticated data and proposed effects/observations. Let `R` be the relation checked by the computation proof.

The key prerequisite is a correspondence implication of the form:

```text
ValidAnchor(Z_i) and R(Z_i, w_i, Z_(i+1))
  imply a transition of the exact admitted Core semantics,
        the prescribed complete observation/output commitment,
        and ValidAnchor(Z_(i+1)).
```

The initial `ValidAnchor(Z_0)` must be established or declared as an external assumption. A cryptographically sound IVC proof of repeated R, plus this correspondence and commitment binding, can then justify the declared prefix claim. A proof from a trusted checkpoint proves that continuation; it does not retroactively prove genesis or earlier events.

The relation has to enforce, or consume separately checked evidence for:

1. **Semantic coverage:** all relevant action/effect/rule obligations, simultaneous effects, checked numeric semantics, lazy evaluation and selected error/order behavior. The producer cannot choose a convenient subset of dependencies.
2. **State and summaries:** authenticated reads/writes, identity nonreuse, references, query membership/absence/ranges, correct initial indexes/aggregates and every maintenance delta. A count rooted in unchecked initial data is still unchecked.
3. **Exact binding:** module/schema/profile, original request and context, lineage/event position, result-state identity, ordered outputs/commands and any policies actually included in the guarantee.
4. **Transitions between contracts:** admission, module replacement, schema migration, new circuit/checker keys and the required initial-state anchor under the incoming semantics.
5. **Observations:** a checked exact expansion or reviewed versioned interpretation for compact traces. A valid proof of a final state alone does not establish which command occurrences or failures were produced.

A privately constructed Rust `Checked<T>` is useful within a trusted native operation; a producer-created token cannot become a premise for an independent cryptographic verifier. Proving R correct and proving an instance of R are separate jobs. The producer may remain untrusted only when the independent relation really checks the whole claim.

A prefix certificate for committed events does not automatically certify unrecorded denied/error attempts. If such outcomes are independently attested, their exact request/context and separate claim must be bound. A proof that a request was denied is not permission to commit it.

## 5. Core-specific cost and compatibility obstacles

Core uses SHA-256 domain hashing of canonical JSON and MuHash3072 state identity. Source inspection of [muhash.rs](../../../../crates/behavior-store/src/muhash.rs) shows **twelve SHA-256 expansions per `element(content_hash)`**, arithmetic modulo `2^3072 - 1103717`, normalization and hashing of the normalized accumulator. [canonical.rs](../../../../crates/behavior-core/src/canonical.rs) fixes canonical byte/hash behavior. These are exact code observations, not estimated circuit constraints or proof timings.

Consequently:

- Efficient native updates are not necessarily efficient prime-field circuit operations. Measure canonical SHA and non-native 3072-bit arithmetic inside the selected proof backend.
- A prover-friendly auxiliary tree can be introduced as a separate representation, but its relationship to authoritative StateId must be proved/checkable. Merely publishing both roots is not correspondence.
- Replacing commitments, event hashes or profiles is a versioned identity/compatibility decision. It cannot silently preserve old IDs. New occurrence IDs derived from new event IDs need an explicit versioned interpretation; historical published events remain immutable.
- If every new event still must hash the old expanded decision bytes, lazy storage alone does not remove the Ω(B) hashing-input work. Asymptotic improvement needs an explicit new event/evidence commitment contract or another demonstrated exact mechanism.
- Existing full-world/corruption-detection observations matter. An independent proof can remain mathematically valid when historical data later becomes unavailable or corrupt. A new proof-verification API may report that distinction, but an old replay/data-audit API cannot silently stop inspecting data it promises to validate.

Safety Models/Lean certificates remain build-time artifacts. Core auxiliary indexes and proof state must have explicit meanings, reconstruction and validity rules; they cannot become hidden business state. This research does not authorize any new governance or approved-module mechanism.

## 6. Cost model for choosing a candidate

Use measured functions rather than a universal constant-cost promise:

```text
Native shared-evidence update
  = dependency selection + affected execution/checking + new object construction
    + persistence/publication + amortized initialization/rebuild.

Accumulated proof production
  = witness generation + encoded step/memory/hash constraints
    + folding + any compression/preprocessing/finalization.

Independent proof consumption
  = expected-subject/key validation + proof verification
    + relevant output/query proofs and transfer.

Replay/export
  = support retrieval + reconstruction + required semantic/data checks + Ω(B).
```

These are accounting identities, not established complexity bounds. Do not double-count overlapping phases or omit final memory checks, proof closure, verifier-key work or initialization. With async proving, “commit latency” must not hide a growing unproved queue. Report sustainable throughput, proof lag and recovery state along with per-event latency.

For an eligible total local rule plus count, a hybrid may reduce encoded work to authenticated changed paths and preserved summary obligations. For arbitrary partial queries or global rules whose complete dependencies change, proving correct execution may still require broad state work. Keep full language coverage as the target with sound fallback; do not declare unsupported difficult cases solved by excluding them from the comparison.

## 7. Publication, proof status and availability

Keep at least three independent findings:

| Finding | What it establishes | What it does not establish |
|---|---|---|
| Native checked and committed | Existing selected native/Core/backend guarantee for the exact event | Independent succinct attestation of the prefix |
| Proof verified through exact H | The declared relation/prefix claim under its assumptions | An unproved suffix, current external authorization, physical command delivery or data availability |
| Replay data available and checked | Required historical inputs and objects can be reconstructed/audited | Cryptographic validity of a different or unchecked prefix |

Synchronous publication requires the needed proof before its declared attested commit boundary. Asynchronous publication can preserve native validation while attestation catches up, but that is an explicit product/trust choice; report exact attested H. The proof sidecar should bind an already published exact event rather than rewrite that event later. Recovery must account for the prover's continuation state or measured reconstruction.

Both routes retain exact-parent atomic publication, durable referenced objects under the selected backend contract, and original-event retry behavior after a lost acknowledgement. A new candidate or proof must not duplicate command occurrences. Invalid losing candidates must not mutate canonical materializations or accumulated proof state. Proofs do not make physical host execution exactly-once.

## 8. Discriminating experiments before architecture selection

No experiment below has run in this research turn. They define the smallest evidence needed to choose, not an implementation mandate.

1. **Semantic witness/checker correspondence first.** Use the public create fixture with positivity and a real count bound. Establish the checker’s complete relation to reference semantics, including new-ID, aliases, Ref targets, query absence and simultaneous effects. Include allowed creation 1000 and rejected 1001. Mutate every essential premise. Prove/check the applicable generic correspondence; finite tests alone cannot establish it.
2. **Paired native representations.** Compare current full records, typed cleanup, and shared normalized evidence with identical input/module. Measure CPU/allocation/parsing/hash work, unique stored/transferred bytes and full export. Determine which steps still touch all N.
3. **Three proof encodings of the same claim.** Compare a broad interpreter/compiled guest, a semantic witness checker, and incremental VM/RAM machinery where a usable artifact exists. Publish the actual relation/image/key identity, C and K per logical event, witness generation, proof generation, compression, memory and verification. A different or weaker statement is not a faster solution.
4. **N and H independently.** Reuse N=128/512/2048/8192, fixed event windows, and increasing history. Include empty caches, first independent verification, changed D, multiple rules/query shapes and command-only events. Test initial memory, final memory, proof closure and continuation/epoch boundaries rather than timing only an interior fold.
5. **Hash/state compatibility.** Measure existing SHA/MuHash in the chosen encoding. Compare preserved commitments versus an explicitly versioned auxiliary representation, including a checked bridge if retained IDs are claimed.
6. **Adversarial composition and crash/retry.** Omit query members/effects, forge initial summaries, use wrong roots/module/profile/context, reorder or duplicate commands, omit a microstep, supply stale/corrupt objects, interrupt native publication/proof publication and lose acknowledgements. Prove sound relation coverage and ensure actual independent verification rejects broken witnesses. Report availability failures separately from mathematical counterexamples.
7. **Decide the operational guarantee.** Evaluate both synchronous proof-before-attestation and native-commit/async-attestation with full steady-state proof backlog, recovery and independent consumption costs. Choose budgets before final evaluation in specified environments; do not infer Core throughput from unrelated cryptographic microbenchmarks.

## Decision and remaining uncertainty

**Take forward A1, B1 and C1/C2 as explicit comparators.** The hybrid is the leading research hypothesis because it targets both N-dependent evidence work and H-dependent independent verification, while preserving a path to complete audit reconstruction. It is not proven best, complete, fast or production-ready. A useful result may select A1 alone, or a guest-based proof route, if hybrid correspondence/circuit/operational costs are excessive.

The blocking unknowns are the exact complete step relation and its proof, proof-friendly authenticated state access without hidden world scans, initial/updated summary correctness, SHA/MuHash cost, mature public backend artifacts, cold rebuild/data availability, and the intended proof-publication guarantee. These are the next investigation targets. The first solution proposal alone was incomplete, and merely adding Nova beside it would also be incomplete.

Detailed primary-source notes: [IVC and execution encodings](ivc-findings.md), [composition and trust boundaries](composition-findings.md). No external theorem, source inspection or publisher benchmark is presented as an independently checked proof or measurement of the proposed Core design.
