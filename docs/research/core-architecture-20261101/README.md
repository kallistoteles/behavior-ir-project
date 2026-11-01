# Core architecture synthesis, 2026-11-01

The recommended architecture is [En ny arkitektur för Core](../../architecture/core/README.md).
It makes an explicit choice after reviewing the 13 prior investigation areas and
three independently developed alternatives. The recommendation is a design, not
a new latency measurement, completed implementation proof or production change.

The alternatives retain their own tradeoffs and may differ from the recommendation:

- [Fixed semantic derivation machine](candidates/semantic-kernel.md).
- [Proof-preserving delta compiler](candidates/delta-compiler.md).
- [Small certified-transition checker](candidates/certified-transition.md).

The final design selects the checker as semantic authority. Incremental plans and
the complete evaluator produce derivations for that checker. It deliberately
specifies a new deterministic observation-recipe commitment, separates semantic
event identity from auxiliary/proof identity, and requires synchronous final
certification. Read the recommendation for normative decisions; the candidates
are comparative research, not three simultaneous contracts.

The [selected primary-source snapshot](sources/README.md) preserves cited Core
reports and source bytes independently of temporary checkouts. Previous sealed
study artifacts are unchanged. The [review record](review.md) records the final
adversarial review and documentation checks.
