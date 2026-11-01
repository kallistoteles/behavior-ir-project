# Architecture options after the Core 031 single-create profile

**Date:** 2026-10-28. **Scope:** primary-source research and architectural recommendations; no implementation or dependency approval. **Measured Core baseline:** commit `a8215c1`, with the native profile based on `6de1c8e`. External artifacts were read, not independently built, kernel-rechecked or benchmarked against Core.

The strongest direction combines three different jobs: retain independently checked typed data across internal boundaries; maintain complete ordered dependencies and results incrementally; represent reusable evidence independently of the expanded audit document. Git is a useful structural analogy, but authenticated computation and incremental compilers provide more directly relevant correctness models.

## Measured questions to answer

The [single-create profile](../single-create-20261028/report.md) gives one create at N=8192 a 4,085,191-byte decision: 79% trace, 10% observed fields, 8% complete parent universe, 3% query membership. Three predicates execute in evaluate and again during commit reproduction, while large evidence structures are materialized. Uninstrumented medians are 277 ms evaluate and 1,658 ms commit. A representative instrumented commit spends 335 ms of exclusive time in record validators, 99 ms in two strict decodes, and 156 ms converting Store documents to JSON before hashing. These are measured facts; external architectures below have no measured Core speedups.

The exact same decision already compresses losslessly to **94,113 gzip bytes** in the retained artifact. That establishes substantial representational repetition, not that compression alone removes construction, validation or hashing. Physical compression and a logically different evidence contract are separate choices.

## Decision matrix

| Candidate model | Which measured cost it targets | Existing evidence class | Compatibility boundary | Recommendation |
|---|---|---|---|---|
| Checked typed values and borrowed record views | Repeated strict decode, typed conversions and JSON clones | Rust ownership discipline; established Serde facilities; Core correspondence unproved | Can aim to preserve existing bytes, errors and profiles | First bounded engineering investigation |
| Authentikit-style authenticated computation and verified reuse | Repeated evidence and repeated deserialization together | Publisher-mechanized Rocq/Iris theorems, with explicit language/serialization TCB | Local reuse may preserve bytes; compact witnesses require a new contract | Strongest new formal design reference |
| rustc/Salsa-style ordered dependency graph | Recompute/materialize only affected rule results | Production implementations; not a machine-checked Core theorem | Internal change can preserve outputs; avoids output work only with sharing/lazy export | Pair with typed values and evidence sharing |
| Normalized/columnar traces and persistent measured sequences | Repeated rule metadata and owned per-row JSON trees | Arrow specification, persistent sequence algorithms | Internal representation can retain old export; new wire encoding is versioned | Small representation experiment before a general engine |
| Local reasoning/frame rules plus exact view maintenance | Explain why unchanged validity survives; update affected global properties | Formal separation-logic frameworks and existing IVM results, each with its own scope | Needs complete admitted-IR/effect/observation correspondence | Mathematical foundation, not a library replacement |
| Verified authenticated maps/range structures | Replace complete-world transfer with checkable access/update witnesses | Authentikit, Plebeia, Isabelle ADS, range-proof literature; differing proof scopes | New index/evidence and snapshot correspondence decisions | Investigate for a versioned evidence profile |
| Prolly/content-defined trees and verified copy-on-write storage | Stable structural sharing, incremental persistence and snapshots | Production implementations and separate verified-storage research | Physical layout may be private; exposed roots/contracts must be versioned | Useful storage design references; not semantic proofs |
| Exact journal plus audit projection and authenticated history anchors | Avoid repeating large decisions/prefixes on ordinary reads and commits | Existing Core event/replay model; RFC/CCF authentication mechanisms | Omitting current logical evidence or old corruption checks changes the contract | Separate history/evidence design, not a quick cache |
| Recursive verifiable computation / Nova | Compact independently checkable accumulated execution evidence | Cryptographic security arguments and public implementation | New arithmetic/circuit/execution and cryptographic trust model | Defer; no cost case yet |

## 1. Checked typed values instead of JSON round-trips

Serde supports borrowing strings/bytes from input; `RawValue` can retain a valid JSON fragment without constructing an owned `Value` subtree. It preserves original formatting. These are established representation facilities, not Core-validation guarantees. Sources: [Serde lifetimes](https://serde.rs/lifetimes.html), [serde_json RawValue](https://docs.rs/serde_json/latest/serde_json/value/struct.RawValue.html).

**Core proposal:** decode and validate an incoming record at its actual trust boundary, producing a private checked value plus a version-specific borrowed/owned view. Reproduction, hashing and bundle construction consume that representation. Internally generated checked values can use native authority tied to the exact module, parent and profile; deserialized producer claims cannot manufacture it. Core already has `CheckedEvaluation` and prepared snapshots, so audit and deepen those seams rather than inventing a second evaluator.

A Core-valid wrapper must still reject duplicate keys, noncanonical numbers, wrong types, unknown/null fields and invalid version/profile combinations, with the same selected errors. `RawValue` alone does none of the full Core semantic checking. Escaped strings may need allocation. Retaining a canonical byte buffer is useful only if its complete content was checked; excluded top-level hash metadata still receives the existing canonical-value checks. Domain-tagged hashes remain separate.

The first experiment should target the measured strict-decode → stringify → strict-decode → owned v0.8/v0.7 conversions, preserving the exact old bytes and all archived profile tests. It should measure complete evaluate/commit/replay/recovery costs and object lifetimes, not merely parser throughput.

## 2. Authentikit: formal reuse of authenticated data and decoded values

The CCS 2025 Authentikit work mechanizes authenticated-computation correctness/security in Rocq/Iris, including proof-reuse buffering and caching already-deserialized authenticated values. Its proof concerns translations into a formal language; faithful correspondence to compiled OCaml remains trusted. Its benchmarks replace the verified serializer with OCaml Marshal, so the benchmark executable is not an end-to-end verified implementation. Sources: [paper, especially §§6 and 8](https://iris-project.org/pdfs/2025-ccs-veriauth.pdf), [public artifact](https://github.com/jtassarotti/veri-auth).

**Core proposal:** use its separation between untrusted evidence production, authenticated data access and checked reuse as the main formal reference. It directly addresses the two costs we observed together: repeating evidence and decoding previously encountered values. A Core adaptation must additionally bind module/schema/profile, exact history, typed captures, complete relevant mutations and all normative observations. Caching an authenticated value proves its content correspondence, not that an arbitrary Core invariant holds.

Independent proof builds and transitive assumptions must be audited before adoption. Rocq results are not automatically Lean results or proofs about Core's Rust implementation. See the companion [authenticated-structure source note](authenticated-structures.md) for precise proof boundaries and related verified structures.

## 3. Incremental compiler architecture: ordered dependency reuse

rustc's red-green algorithm tracks query invocations, arguments, results and dependencies. A dependent result may be reusable when its dependencies remain unchanged. Crucially, it revisits dependencies in their original order: changed control flow can make later old dependencies inappropriate. Salsa exposes memoized pure queries over tracked inputs. [rustc incremental compilation](https://rustc-dev-guide.rust-lang.org/queries/incremental-compilation.html), [Salsa internals](https://salsa-rs.github.io/salsa/how_salsa_works.html).

**Core proposal:** key checks and evidence fragments by their complete semantic inputs rather than a monolithic state JSON. Track entity/field values, query membership, absence, reverse references, captures, module and context. Ordered/lazy evaluation and first-error selection are outputs to preserve. A missing dependency invalidates reuse; unknown effects fall back to reference execution. Persistent cache corruption/freshness requires its own checked boundary.

This model is broader than value caching: it can retain a fragment of the ordered trace and its observations. However, visiting all cached rule nodes or flattening all trace nodes on every commit still costs O(N). The reuse index and evidence representation must avoid that traversal for eligible cases. No universal delta-only guarantee follows from adopting a query engine.

[Build Systems à la Carte](https://www.microsoft.com/en-us/research/publication/build-systems-la-carte/) supplies an executable framework for separating rebuilding decisions from scheduling. Its value here is designing precise reuse semantics, not importing a build scheduler or claiming a formal proof of Core.

## 4. Normalize repeated traces; use persistent ordered sequences

Arrow dictionary encoding represents repeated values by indices into a dictionary. Persistent measured sequences such as finger trees support sharing and efficient sequence composition/splitting using monoidal annotations. Sources: [Arrow dictionary layout](https://arrow.apache.org/docs/format/Columnar.html#dictionary-encoded-layout), [Hinze–Paterson finger trees](https://www.staff.city.ac.uk/~ross/papers/FingerTree.html).

**Core proposal:** store rule metadata once and retain ordered per-subject outcomes/observations in compact typed blocks. Represent an audit sequence as reusable ordered chunks; expand the existing JSON only where requested. This targets the repeated rule hash, obligation metadata and JSON keys in the 3.23-MB trace. A Merkle-DAG and a columnar block layout can be combined; they solve sharing and within-block repetition respectively.

Preserve exact subject identity, trace ordering, skips, selected failures, numeric types and all duplicate command occurrences. Dictionary indices need deterministic identity/serialization rules if exposed. Counts and first-failure summaries need proved composition laws; checked signed sums are not interchangeable with mathematical monoids if intermediate overflow is observable. A tree's structural hash is not the SHA-256 of its flattened old JSON.

Changing only internal storage may preserve the existing format, but full exports still require O(B) work. Changing the canonical wire object requires explicit versioning. Arrow is inspiration for a layout; embedding the entire Arrow runtime is not justified. Likewise, Cap'n Proto offers direct-access encoding, but its object encoding is a tree and ordinary encoders are not canonical by default; it is not a drop-in authenticated DAG or replacement for Core's strict validation. [Cap'n Proto encoding and canonicalization](https://capnproto.org/encoding.html).

## 5. Local reasoning and exact global summaries

Separation logic's frame principle supports reasoning about the resources a command affects while preserving a justified disjoint frame. Iris is a Rocq-verified framework for such reasoning. Sources: [Brookes' tutorial and frame lemma](https://www.cs.cmu.edu/~brookes/papers/mfps2006tutorial.pdf), [Iris project](https://iris-project.org/).

**Core proposal:** prove a finite-map analogue for supported local rules, paired with exact summary updates for supported global rules. In the current example, unchanged entities preserve `x > 0`; the created entity is checked; a complete fresh-identity delta increases cardinality by exactly one. This supplies the preservation justification that content hashes alone cannot supply.

Separation of entity identities is insufficient when a rule reads another entity, query result, context, or reference graph. Such dependencies must be included or discharged separately. The [existing Core 031 count correspondence](../../evidence/algorithms/correspondence.md) already explains fixed captures, complete deltas, totality, checked overflow and observations. DBSP/Differential Dataflow remain valuable foundations for summaries; they do not remove the current evidence-output lower bound. There is no need to import a general proof framework to prove the first small correspondence lemma.

## 6. Journal, audit projection and authenticated history

Core already has exact event history and deterministic replay. Merely recommending event sourcing adds nothing. The architectural question is whether a new versioned event can retain authoritative inputs, exact parent and new evidence references, while a separate deterministic projection reconstructs the complete audit view.

RFC 9162 specifies Merkle inclusion and append-consistency proofs. CCF exposes receipts that can be checked offline. These establish authenticated history claims under their defined anchors; they do not independently establish Core invariant preservation or permission to commit. [RFC 9162 §2.1](https://www.rfc-editor.org/rfc/rfc9162.html#section-2.1), [CCF transaction receipts](https://ccf.dev/main/use_apps/verify_tx.html).

**Core proposal:** distinguish a checked semantic anchor, an authenticated historical interval, command-page extraction, and full audit rendering. A consumer with a validated exact anchor may verify a continuation differently from a fresh consumer that must rebuild from genesis. Both costs and support availability must be explicit. Command-only events, multiplicity, lost acknowledgement and equal StateId at different positions remain exact-history obligations.

An inclusion proof does not prove that no query member, incoming Ref, command or event was omitted. Existing API behavior that detects corruption anywhere in an old interval cannot silently become proof of a smaller uncorrupted subset. Such a change requires a reviewed observation/version contract, not a cache keyed only by StateId. Checkpoints cannot acquire governance authority by being signed. Safety Model/Lean build certificates remain separate artifacts; this proposal concerns Core runtime evidence.

## Authenticated storage candidates: which guarantees are already formalized?

- **Plebeia:** the authors report F* verification of core Merkle-Patricia operations, serialization and relative hashing security, while extracted modules still link unverified parts. This is a concrete implementation-verification reference, not a complete Rust storage package or Core proof. [Paper](https://arxiv.org/abs/2106.04826).
- **Merkle B-trees:** authenticated range boundaries and interior structure address omitted-result detection for ordered queries. Core additionally needs a checked correspondence between the index and the complete authoritative entity set; a malicious producer cannot be allowed to choose an incomplete index. [Original algorithm](https://users.cs.utah.edu/~lifeifei/papers/sigmod06-btree.pdf).
- **Prolly trees:** Dolt describes content-defined chunking of sorted data, with shape determined by contents and improved sharing across local updates. It is a useful layout/canonical-rebuild model, not a machine-checked semantic or hostile-query guarantee. [Dolt's design](https://www.dolthub.com/blog/2022-06-27-prolly-chunker/).
- **VeriBetrKV:** the authors report verified refinement of a copy-on-write storage system to a crash-safe dictionary. Its disk assumptions do not give adversarial-storage authentication. Borrow its durable-publication reasoning when writing evidence objects before atomically publishing a new root. [OSDI paper](https://www.usenix.org/system/files/osdi20-hance.pdf).

The [companion source review](authenticated-structures.md) states the exact proof boundaries, artifact accessibility, missing-object controls and cold-rebuild requirements. State-tree identity and exact historical event identity must remain distinct for every option.

## 7. Recursive proofs: potentially powerful, currently disproportionate

Nova provides an incrementally verifiable-computation construction using folding, with a cryptographic analysis and a public Rust implementation. Its concrete scheme/implementation variants have distinct assumptions; some optional compression commitments require setup. [Nova paper](https://eprint.iacr.org/2021/370), [implementation and assumptions](https://github.com/microsoft/Nova).

**Core assessment:** potentially useful for an independent consumer verifying very long histories, but there is currently no evidence it reduces end-to-end producer latency for this workload. Encoding admitted Core execution, checked errors, reference integrity, ordered observations and command semantics into a proved circuit/machine is a large new correspondence task. Proof validity also does not guarantee replay input availability. Keep this as a long-term research option; do not introduce cryptographic proof generation to avoid an ordinary duplicate JSON parse.

## Combined architecture worth testing

The recommended candidate is a composition, not a choice of a complete external engine:

1. **Checked typed core objects** throughout a single operation, with canonical serialization at explicit boundaries.
2. **Complete ordered dependency tracking** and small preservation lemmas to decide what can be reused.
3. **Persistent, normalized evidence fragments** whose independent interpreter establishes the complete claim.
4. **Explicit export and history protocols** distinguishing full audit materialization, checked continuation and fresh rebuild.

An immutable hash identifies a value; a checked derivation establishes its validity; a complete coverage argument establishes that nothing relevant was omitted. These are three separate obligations.

## Minimal comparison protocol before selecting an implementation

- Candidate A: preserve current bytes and replace the repeated record conversions with one checked representation. Compare all observable results, first errors, versions and replay, and measure allocation/copy volume plus end-to-end times.
- Candidate B: prototype a normalized persistent trace representation for the same public fixture. Recover the exact old JSON, including deliberate failure/skipped traces; measure newly constructed nodes, storage, cold reconstruction and full export. Do not call this an asymptotic commit improvement if commit still flattens everything.
- Candidate C: specify a versioned authenticated witness for local positivity plus cardinality. Independently check initialization, complete delta/identity coverage, count updates, stale roots, omitted members and simultaneous effects. Demonstrate a valid 1000th create and rejected 1001st create, not only a constant-true rule.
- Candidate D: compare one-record command pages at increasing history with an exact checked anchor. Test unavailable/corrupt support, command multiplicity, conflicting commits and persisted-before-ack recovery. State any changed corruption-detection contract explicitly.

All candidates need a frozen public reference corpus, source/tool identities, at least three repetitions and independent growth axes. Report soundness/correspondence, supported semantic coverage, and practical capacity separately. No external primary source or attractive benchmark establishes Core correctness automatically.
