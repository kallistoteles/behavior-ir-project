# Core investigation notes

The [complete study inventory](investigation-map.md) lists 13 main parts, from
Core 029–032 and the first-principles/greenfield research through later profiling
and the architectural reassessment. It distinguishes measurements, prototypes,
formal scope and proposals that were not implemented.

The [recommended new Core architecture](../architecture/core/README.md) now
synthesizes all 13 areas and compares three independently developed alternatives.
It selects a small semantic checker as authority, with untrusted incremental/full
producers, authenticated retained state, a new evidence profile and synchronous
accumulated certification. Its correctness chain, durability protocol and absolute
performance gates are explicit. Implementation, end-to-end proof and millisecond
performance remain unestablished. The
[clarified scope](core-redesign-reassessment-20261101/scope.md) requires a mathematically
correct chain through initialization, ordinary transitions and independent history
verification, with absolute millisecond-scale targets. Every expensive step must be
explained and compared with established researched methods; moving its cost elsewhere
does not answer the question.

The completed [existing-format optimization study](core-final-investigation-20261031/report.md)
includes a cumulative, validated patch: strict-decode/typed reuse, bundle ownership transfer,
buffered canonical hashing and borrowed document views. In the fresh six-case comparison,
commit medians improve 25.11–38.37% and evaluate+commit+serialization improves 22.06–30.82%.
All 1,215 measured processes pass complete-output checks, and all repository gates pass.
That study does not settle the architectural objective. Its report preserves the small
command-v2 serialization regression and identifies deferred
allocator consolidation in the bounded diagnostic, including its sparse/unknown samples.

| Execution date | Investigation | Preserved result |
| --- | --- | --- |
| 2026-10-30 | [Repeated strict decoding](core-continuation-20261029/report.md) | Experimental same-format patch; 648 Core/Store tests passed and compared outputs match. |
| 2026-10-31 | [Typed record materialization](core-typed-record-20261031/report.md) | Three-arm comparison; array compatibility fallback; 656 Core/Store tests passed and compared outputs match. |
| 2026-10-31 | [Residual profile and serialization context](core-residual-profile-20261031/report.md) | 156 successful probes with exact output bytes; 38 focused Rust controls and eight collector tests passed. No new runtime optimization. |
| 2026-10-31 | [Archived bundle ownership](core-bundle-ownership-20261031/report.md) | One temporary clone removed; 62 successful byte-equal probes; 671 Store tests passed, 24 ignored; modest, mixed timing benefits. |
| 2026-11-01 | [Existing-format optimization and profiling](core-final-investigation-20261031/report.md) | Six-arm cumulative comparison; hash streaming and borrowed views; 1,215 byte-equal measured processes; all 13 owner gates passed; scoped compatibility results, not the final architectural solution. |
| 2026-11-01 | [Architectural reassessment](core-redesign-reassessment-20261101/scope.md) | Reopened original goal: explain required work and researched replacements across all three correctness stages. No new latency or implementation-proof claim. |
| 2026-11-01 | [New Core architecture](../architecture/core/README.md) | Recommendation from the full inventory and three alternatives; explicit semantics/checker/history chain, identity and evidence redesign, atomic durable publication, complete-language and absolute-latency build gates. Design, not a measured implementation. |

Each investigation retains its protocol, patches, source/binary identities, controls and measured evidence.
Performance figures belong to their individual campaigns; the final comparison is measured
directly rather than composed from older percentages. Earlier artifacts remain unchanged.
The compatibility report classifies retained contract work, generic serde semantics, maintenance risks,
unadopted reuse designs and physical mechanisms that the evidence does not uniquely establish.
