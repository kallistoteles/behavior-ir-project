# Feature Specification: Verified Incremental Transitions — Comparative Investigation

**Feature Branch**: `031-scalable-execution-evidence` (current branch; feature selection is independent)

**Feature Directory**: `specs/032-transition-verification-study`

**Created**: 2026-10-28

**Status**: Draft

**Repository**: `kallistoteles/behavior-ir-core`

**Input**: Starting from the first-principles findings of Core 031, establish a common mathematical contract and executable comparisons for correct incremental transitions and independent historical verification. Investigate what can replace repeated whole-state evidence work, evaluate accumulated proofs including Nova early, and recommend an architecture from correctness and measurements rather than prescribing one. The deliverable is a bounded comparative investigation, not a production redesign or another literature-only survey.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Know exactly what each candidate establishes (Priority: P1)

A maintainer can identify the complete inputs, observable result, retained information and trust assumptions of a proposed transition verifier before comparing its performance.

**Why this priority**: A faster implementation that preserves a weaker property does not solve the observed problem.

**Independent Test**: Review one common transition contract against the existing reference behavior and finite cases that distinguish correct execution, state safety, historical identity, authorization and reconstruction.

**Acceptance Scenarios**:

1. **Given** the same live entities but different histories of used identities, **When** creation is assessed, **Then** the contract distinguishes the permitted creation from reuse of a removed identity.
2. **Given** an operation whose incorrect result still satisfies a safety invariant, **When** its result is checked, **Then** exact-transition correctness rejects it.
3. **Given** a valid computation proof but missing historical data, **When** verification and replay are requested, **Then** proof validity and reconstruction availability are reported separately.

---

### User Story 2 - Compare executable incremental strategies against one reference (Priority: P1)

An investigator can run at least two materially different transition-verification strategies on the same public model and determine whether justified reuse reduces work without losing required behavior.

**Why this priority**: Core 031 measured substantial evidence work despite successful semantic reuse; the next decision requires executable evidence and a sound correspondence argument.

**Independent Test**: Execute the common model through the reference and each candidate, compare complete applicable observations, and run deliberate premise violations against the actual checking path.

**Acceptance Scenarios**:

1. **Given** positive-valued entities and a cardinality limit of 1,000, **When** the 1,000th and then 1,001st creations are attempted, **Then** candidates agree with the reference on acceptance/refusal and resulting observations.
2. **Given** a retained count, reference index or prior rule result, **When** its initialization, dependency coverage or update premise is deliberately broken, **Then** the checking path detects the defect rather than accepting the claimed result.
3. **Given** a valid execution outside a candidate's optimized fragment, **When** it is encountered, **Then** exact reference behavior or an explicitly scoped unsupported experiment is reported; witness rejection is never presented as a business denial.
4. **Given** a one-field update with many affected rules, **When** it is compared with a local update, **Then** the results and measurements expose the different dependency costs.

---

### User Story 3 - Establish the value and cost of an accumulated proof (Priority: P2)

An independent consumer can check a bounded history claim without trusting the producer's earlier acceptance, and a maintainer can see the additional production cost and assumptions.

**Why this priority**: Incremental execution and compact storage alone do not establish inexpensive independent verification of a long prefix.

**Independent Test**: Produce a real accumulated proof for a declared common-model claim, verify it in a fresh consumer context, and reject altered subjects, endpoints and semantic witnesses.

**Acceptance Scenarios**:

1. **Given** a proof for an exact initial anchor and committed prefix, **When** the expected module, history endpoint or command commitment is changed, **Then** independent verification rejects the altered claim.
2. **Given** multiple internal proof steps for one operation, **When** resource use and coverage are reported, **Then** semantic operations and proof steps are counted separately and incomplete operations cannot be reported as committed.
3. **Given** native commits beyond the latest verified prefix, **When** asynchronous proving is assessed, **Then** the proved endpoint and pending work remain explicit.
4. **Given** a command-only event or a lost acknowledgement, **When** the claimed history is checked or recovered, **Then** exact event identity and duplicate command occurrences remain correct even when state content is unchanged.

---

### User Story 4 - Make a reproducible architecture decision (Priority: P2)

A maintainer can choose further work using a dossier that compares equivalent claims, complete costs, supported coverage and unresolved premises.

**Why this priority**: Neither a favorable microbenchmark nor a generic external theorem establishes a useful Core architecture.

**Independent Test**: Another maintainer can reproduce the declared comparisons and trace every recommendation to a checked obligation, an actual run or an explicitly unresolved finding.

**Acceptance Scenarios**:

1. **Given** increasing live state at fixed history and increasing history at fixed live state, **When** measurements are compared, **Then** construction, update, proof production and independent verification growth are distinguished.
2. **Given** empty caches or lost derived information, **When** a candidate is restarted, **Then** initialization/rebuild costs and reconstruction requirements are included.
3. **Given** no candidate meets its stated usefulness criteria, **When** the investigation concludes, **Then** a precise no-go or narrower follow-up is documented without declaring an unsupported design correct or deployable.

### Edge Cases

- Empty queries, absent keys and new rows entering previously empty results.
- Missing and extra query members, stale counts and incomplete incoming-reference indexes.
- Creation, removal, aliases, reused removed identities and simultaneous effects.
- Checked overflow, partial expressions, lazy branches, first-error and rule/subject ordering.
- Equal live state at different histories; command-only events and repeated identical command intents.
- Conflicting commits, interrupted publication, persisted-before-acknowledgement recovery and unfinished proof steps.
- Changed context/captures, module or schema; incompatible proof/checker versions and incoming-state validation.
- Corrupt or unavailable support, missing proof data, cold reconstruction, timeouts and resource exhaustion.

## Requirements *(mandatory)*

### Functional Requirements

#### Common meaning and evidence boundaries

- **FR-001**: Define one reviewable reference contract for the exact decision, resulting operational state, ordered command occurrences, selected failures and normative observations. Distinguish execution correctness from invariant preservation, authority/provenance and data availability.
- **FR-002**: Include every input that can change that result: live state, historical identity use, exact lineage/history, applicable module/schema/profile and request/context. State which inputs or authority assertions remain externally trusted. Define sufficient retained information separately for state replay, execution re-evaluation, command replay and full audit reconstruction.
- **FR-003**: Define the exact meaning of every reused view, summary or prior result, including initialization, complete dependency coverage, update preservation and recovery. A digest, producer-provided completeness label or successful subset of checks MUST NOT establish these premises by itself.
- **FR-004**: Establish the selected candidates' mathematical correspondence to the reference before recommending them as correct. Reuse relevant established formal results where their premises fit; identify the exact theorem scope, representation mapping, unchecked components and assumptions. Required correspondence claims MUST have machine-checked support for the declared experimental scope; tests alone MUST NOT be labeled a universal proof.

#### Bounded executable investigation

- **FR-005**: Use a public domain-neutral reference model with positivity and a genuine cardinality boundary. Add controls for references, lifetime identity, contextual dependencies, command-only events and command multiplicity. Separate the shared comparison fragment from additional supported/unsupported cases; do not imply coverage beyond the actual claim.
- **FR-006**: Execute at least two materially different strategies against the same reference, selected from inductively maintained views, independently checked transition witnesses, verified incremental transformations or a justified alternative. Strategies may share supporting components; they MUST differ in the correctness/reuse mechanism being evaluated rather than only serialization or naming.
- **FR-007**: Require equivalent claims and explicit applicability for every comparison. Unchanged-profile paths preserve exact canonical observations. An experimental alternative representation requires an explicit interpretation/reconstruction argument and identification of future version/identity changes. Full audit construction may be deferred only when the promised observations remain recoverable.
- **FR-008**: Observe meaningful failing controls before corresponding new checking/reuse mechanisms. Exercise actual omissions or alterations of initialization, effects, dependencies, summaries, context and output bindings. Distinguish invalid witnesses, unsupported constructs, resource exhaustion and actual semantic denials/errors. Preserve exact reference behavior wherever a candidate claims a fallback.
- **FR-009**: Remain bounded to the shared model and justified extensions needed to discriminate candidates. Full language support remains a future adoption consideration; a deliberately narrow prototype MUST NOT certify arbitrary admitted modules or silently redefine existing Core semantics.

#### Accumulated verification

- **FR-010**: Establish accumulated-proof feasibility early enough to inform candidate selection, and evaluate it through an actual bounded production-and-independent-verification experiment, with Nova as a required concrete candidate for assessment. Compare proof of the same reference computation or a correspondence-justified checker; do not choose a weaker statement to obtain a favorable result. Another proof system may be an explicit comparator, not an unexplained replacement for the requested assessment.
- **FR-011**: Bind the independently verified claim to its exact anchor, lineage, module/schema/profile, semantic/checker identity, endpoint and relevant ordered outputs. Identify genesis, module switches, migrations and authorization as proved obligations or explicit exclusions/assumptions. Authenticate complete state access and summaries wherever they are proof premises.
- **FR-012**: Separate logical transitions from internal proof steps, witness generation, accumulation, compression, parameter preparation and final verification. Assess synchronous publication and asynchronous attestation as distinct operational guarantees. A pending proof or proof for an earlier prefix MUST NOT acquire authority for an unproved suffix.
- **FR-013**: Assess initialization, continuation, closing and recovery costs of the selected state/proof mechanism. Preserving existing identities requires accounting for their exact computation; alternative commitments require an explicit correspondence/version decision. Proof validity MUST NOT imply support availability, physical command execution or fresh authorization.

#### Measurement, disposition and compatibility

- **FR-014**: Freeze reference subjects, candidate claims, workloads, environments, resource limits and usefulness criteria before final comparative evaluation. Reuse Core 031's retained inputs and infrastructure where suitable. Separate source-derived expectations and external publisher measurements from actual local results.
- **FR-015**: Measure live-state and history growth independently, including live populations 128/512/2,048/8,192 and history lengths 8/32/128 where supported. Retain at least three repetitions per declared primary comparison point. For proof capacity limits, retain all attempted points and explicit failures; use at least three declared scales for a measured scaling claim. Mandatory small proof verification cannot be replaced by resource-limited attempts only.
- **FR-016**: Include initialization, affected execution/checking, evidence/witness construction, persistence/publication, proof production, independent checking, full export and cold recovery in the cost model. Report allocation/copy/parse/hash work where measured, distinct output/stored/transferred bytes, peak resources, uncertainty and any unmeasured work. Asynchronous experiments include sustainable throughput and proof lag.
- **FR-017**: Produce a separate disposition for each candidate and consumer profile: local execution, independent checking/replay, and succinct historical verification. State supported behavior, measured benefits/costs, remaining proof obligations, trust changes and adoption requirements. A hybrid is one possible result, not a prescribed architecture. A justified no-go may conclude a candidate; missing mandatory comparisons remain incomplete work.
- **FR-018**: Preserve production semantics, published hashes/records/receipts, existing compatibility fixtures, persistence/replay contracts and unrelated work. Experimental representations and proof dependencies remain isolated and reproducible; changes to shipped formats, governance, deployment requirements or runtime capability require separate scope. Apply existing repository gates to any changed Core code; do not weaken them for an experiment.

### Key Entities *(include if feature involves data)*

- **Reference contract**: Exact transition meaning, observation boundary, operational inputs and reconstruction promises.
- **Maintained meaning**: A stated relation between authoritative information and retained summaries/results, with initialization and preservation obligations.
- **Comparison candidate**: An executable strategy, its mathematical claim, supported scope and complete costs.
- **Transition witness**: Untrusted supporting data whose acceptance requires an independently justified checker.
- **Verification claim**: Exact subject, initial anchor, endpoint, obligations, assumptions and evidence class.
- **Experiment record**: Frozen inputs, source/tool identities, effective conditions, repetitions, outcomes and retained failures.
- **Decision dossier**: Comparison results, candidate dispositions and the next adoption or no-go decision.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A maintainer can trace every compared claim to one common contract that explicitly covers all six boundaries: exact execution, safety, historical identity, authority/provenance, retained information and reconstruction availability.
- **SC-002**: The reference and at least two materially different executable strategies produce zero unexplained mismatches over their shared declared scope. The 1,000th/1,001st boundary, reference/lifetime controls and duplicate-command cases have independently specified expected outcomes; every deliberate essential-premise violation is detected by the relevant checking path.
- **SC-003**: Every correctness recommendation has machine-checked mathematical support for its declared scope, with separately identified source-to-model and implementation trust boundaries. No undocumented assumption, failed obligation or passing finite test is presented as complete proof.
- **SC-004**: At least one real accumulated proof of the declared shared claim is independently verified in a fresh consumer context. Altered subjects/endpoints and invalid semantic witnesses fail verification. Broader unsupported coverage or exhausted capacity is explicitly reported without implying a successful proof.
- **SC-005**: Another maintainer can rerun the declared comparisons from retained public inputs. Primary comparison points have at least three repetitions, independent state/history scaling is reported, and complete lifecycle costs and remaining capacity limits are visible. No invented speedup target is required to conclude the investigation.
- **SC-006**: The final dossier gives a justified disposition for every executed candidate and each of the three consumer profiles, with no production adoption implied. Existing required checks pass for changed code, and no protected historical artifact or unrelated work is modified.

## Assumptions

- This is Core Feature 032, following the completed Core 031 investigation and its additional profiling/research. The current source baseline is `fc73fa36b959aeaf54cff2f38dd190c4389c3fa1` (Core 0.16.0 research branch); planning will pin the actual experimental subjects rather than infer that this is a new release.
- [Core 031's investigation](../031-scalable-execution-evidence/investigation.md), [single-create profile](../031-scalable-execution-evidence/profiling/single-create-20261028/report.md), [first-principles research](../031-scalable-execution-evidence/profiling/first-principles-20261028/research.md) and [IVC/composition research](../031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md) supply the scope. Their measurements are historical reference evidence, not measurements of the new candidates.
- [The persistence contract](../../docs/persistence.md) and constitution 1.1.0 govern compatibility and semantic authority. The actual storage layout, incremental algorithm, proof representation/toolchain and accumulated-proof configuration are planning/experimental decisions.
- Nova is included because the user explicitly requested serious evaluation in a greenfield design. Inclusion does not preselect it or a hybrid for adoption. External artifacts require reproducible versions and qualified proof/implementation claims; no new toolchain or library is assumed verified for Core.
- Numeric resource budgets and usefulness criteria will be declared during planning before final evaluation. Resource failures are valid measured outcomes, not mathematical counterexamples; successful small mandatory comparisons and proof verification are still required for completion.
- No private application access, external production deployment, general query/proof framework, complete Core rewrite, new Safety Model family or release publication is required. Safety Models and their mathematical certificates remain build-time artifacts; all business-state transitions and replay remain ordinary Core responsibilities.
