# Core investigation notes

The investigation is complete under the existing full-record and validation contract.
The [final solution and consolidated findings](core-final-investigation-20261031/report.md)
include a cumulative, validated patch: strict-decode/typed reuse, bundle ownership transfer,
buffered canonical hashing and borrowed document views. In the fresh six-case comparison,
commit medians improve 25.11–38.37% and evaluate+commit+serialization improves 22.06–30.82%.
All 1,215 measured processes pass complete-output checks, and all repository gates pass.
The report preserves the small command-v2 serialization regression and identifies deferred
allocator consolidation in the bounded diagnostic, including its sparse/unknown samples.

| Execution date | Investigation | Preserved result |
| --- | --- | --- |
| 2026-10-30 | [Repeated strict decoding](core-continuation-20261029/report.md) | Experimental same-format patch; 648 Core/Store tests passed and compared outputs match. |
| 2026-10-31 | [Typed record materialization](core-typed-record-20261031/report.md) | Three-arm comparison; array compatibility fallback; 656 Core/Store tests passed and compared outputs match. |
| 2026-10-31 | [Residual profile and serialization context](core-residual-profile-20261031/report.md) | 156 successful probes with exact output bytes; 38 focused Rust controls and eight collector tests passed. No new runtime optimization. |
| 2026-10-31 | [Archived bundle ownership](core-bundle-ownership-20261031/report.md) | One temporary clone removed; 62 successful byte-equal probes; 671 Store tests passed, 24 ignored; modest, mixed timing benefits. |
| 2026-11-01 | [Final Core solution and investigation](core-final-investigation-20261031/report.md) | Six-arm cumulative comparison; hash streaming and borrowed views; 1,215 byte-equal measured processes; all 13 owner gates passed; serialization capacity/touch/allocator investigation closed with explicit limits. |

Each investigation retains its protocol, patches, source/binary identities, controls and measured evidence.
Performance figures belong to their individual campaigns; the final comparison is measured
directly rather than composed from older percentages. Earlier artifacts remain unchanged.
The final report classifies retained contract work, generic serde semantics, maintenance risks,
unadopted reuse designs and physical mechanisms that the evidence does not uniquely establish.
