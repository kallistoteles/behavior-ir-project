# Architecture review and checks

2026-11-01. Scope: the four recommended architecture documents, the comparison
against three independently developed candidates, and the provenance/navigation
of the preserved source bundle. This is a design review, not an implementation
proof, benchmark, proof-assistant run or production-readiness verdict.

Three read-only adversarial reviews covered semantic kernel/identity, incremental
compilation/costs, and publication/proof lifecycle. Reviewers examined the same
recommended documents rather than only their own alternatives.

| Finding | Resolution in the recommendation |
| --- | --- |
| Init's displayed theorem established exact views but did not explicitly require a valid initial state. | Added expected-origin premise, admitted module and initial semantic validity. Explained why an accurately cached failed invariant cannot justify genesis. |
| An underspecified parent could include strategy-dependent certificate/helper roots; occurrence IDs could create a hash cycle. | Defined an acyclic SemanticParent→EventId→CommandOccurrenceId construction. Auxiliary/proof/microstep coordinates are excluded from the semantic parent. |
| Initial request-ID lookup plus parent CAS is insufficient when refusal results leave head unchanged. | Publication atomically compares/inserts unique `(lineage, request_id)` and original digest for both committed and refused results. Identical retries resolve the original before new parent CAS; different digests cannot overwrite it. |
| N/H alone did not freeze the local latency scenario. | Added module/input/output/D bounds, U levels, exact-source protocol requirement, minimum sample count and cold/resident definitions. |

No additional blockers were identified in the ordered checked-sum law, fixed-K
acceptance versus untrusted production, negative query coverage, complete-language
fallback requirement, new observation-recipe profile, legacy adoption, synchronous
final certification or the stated native/machine/emitted-circuit obligations.
This means the design is coherent enough to guide construction; it does not
discharge any of those future obligations.

Documentation verification checks:

- Every local link in the newly authored architecture/candidate/index documents
  resolves. Partial source snapshots retain original internal links verbatim;
  their incompleteness is explicitly documented rather than rewritten as originals.
- All 32 source snapshots match their manifest SHA-256, byte count and the Core
  commit `1a3ae37623cf90b4608a678ef283ee313306d9bb`.
- Git whitespace/diff checks pass.
- The pre-existing sealed final study still verifies: 755 files, 96,292,005 bytes,
  manifest SHA-256 `e54215cedc4de1e150efd8cd0d70b9656ccca6614b7d318b45f7e056a677ad72`.

No production source was edited, no new performance result is claimed, and no
old sealed experiment was regenerated for this architectural synthesis.
