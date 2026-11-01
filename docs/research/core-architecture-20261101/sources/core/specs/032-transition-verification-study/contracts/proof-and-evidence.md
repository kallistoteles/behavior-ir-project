# Accumulated proof, identity bridge and retention

**Contract**: `core032.proof.v1`. A bounded feasibility contract; no production certificate format is introduced.

## 1. Mathematical and implementation authority

The required claim is exact F/J/K execution for the declared model, not mere invariant preservation. Lean theorem checks establish the abstract contract; source-to-model extraction, runtime implementation and circuit correspondence are separately recorded. Audit transitive theorem dependencies permitting only `propext`, `Classical.choice`, `Quot.sound`; reject proof holes, new axioms and native-computation proof axioms. Independently replay checked declarations with the pinned `leanchecker --fresh`; a tool failure is a failed proof gate. Preserve the precise definitions/statements/version and checked artifacts.

Nova's cryptographic argument and implementation are separate trusted components. A successful Nova call does not establish circuit correctness. Review every constrained field/branch and demonstrate mutations. Where a circuit-to-model proof is absent, label it an explicit correspondence assumption and the resulting recommendation conditional. No claim of end-to-end verified Core is permitted.

## 2. Concrete baseline

Nova commit `01b1e2d662a847ed7029770ecbaf6687398899dd`; `PallasEngine`/`VestaEngine`, Pedersen/IPA and Spartan `RelaxedR1CSSNARK`; isolated locked dependency, default features disabled. Do not silently substitute the KZG configuration from an example. Public parameters and verifier keys must be derived from, or independently matched to, the pinned circuit/shape/backend. Producer-provided keys are untrusted inputs.

Fixed-capacity B carries complete typed state and used-ID bits between steps and checks the reference computation. Capacities include live slots, total historical IDs, requests/commands, integer domains and proof-step layout; never identify maximum live population with lifetime capacity. Arrays are padded canonically. Boolean/range, uniqueness and selector checks preserve constant shape independent of witness content.

Minimum experiment: a real accumulated history with at least two finalized logical attempts; include a committed transition and a command-only transition somewhere in the small successful suite. Separate tests cover refusal, remove/reuse, invalid refs/semantic witnesses and duplicate command occurrences. N=1/4/16 denotes attempted circuit live capacities; initial populations and historical ID capacities are separately frozen. H=1/2/8 denotes logical attempt counts, with committed counts separately reported. Larger limits are attempted, not claimed successful in advance.

## 3. Public claim and step relation

Bind module/schema/profile/model/checker versions, exact initial anchor, parent lineage, attempt and commit coordinates, request/context, computed observation/output and final endpoint. Each finalized step establishes the supported checker relation and commitment update. A partially evaluated microstep cannot become a committed semantic event.

Use domain-separated typed length-delimited encodings. SHA-256 digests use two constrained 128-bit limbs or 256 Boolean wires; reduction to one field element is not exact digest binding. In-circuit hashes bind values whose semantics were actually constrained. No unconstrained producer poststate, output root, obligation-success bit or history hash is acceptable.

`verify` success is insufficient by itself: the consumer compares the returned final state, step count and initial state with independently expected claim values. Wrong module, anchor, context, endpoint, command count/order or output digest must fail. Retain a genuine invalid-witness test that still satisfies positivity/cardinality to distinguish exact execution from safety.

## 4. Existing Core identity bridge

The study history commitment is a different experimental profile. Existing Core identities retain their canonical algorithms. The bridge reconstructs exact observations/records from retained support, verifies per-step correspondence to the circuit's bound outputs, and checks canonical Core anchors/endpoints/commands. It must independently link every claimed committed event; comparing only an unconnected final StateId is insufficient.

Combined acceptance requires both the folded semantic proof and this bridge. Include all record/support reads, parsing, rendering, hashing and MuHash work. If this scans the full history/evidence, say explicitly that complete Core-history verification remains linear. No label may imply that SHA chaining has replaced canonical Core history, full reference coverage or data availability.

An experimental-profile-only result may be reported separately, with an explicit interpretation and future version/identity requirements. It does not meet a claimed existing-Core binding until the bridge matches.

## 5. Publication and recovery

Report synchronous publication (proof requirement satisfied before publication) and asynchronous attestation separately. For asynchronous runs record native head, proved/bridged head, lag in events/time, throughput and pending work. The proof covers only its exact prefix; it grants no authority to the suffix.

Retain initialization, continuation, compression/finalization, parameter preparation and recovery costs. Restart checks exact module/shape/anchor/endpoint; a partial/corrupt checkpoint must fail or rebuild from authoritative support. No cached previous acceptance replaces required consumer checking. Proof randomness may change blob bytes without changing the semantic claim identity.

Measure parameter first-use and reuse independently. First-use producer and consumer derive their required parameters/keys inside their timed budgets. Reuse names exact artifacts and includes loading and pinned-recipe/circuit validation; it still performs all proof and identity-bridge checks. Freeze the recipe before the run and retain observed generated-parameter identities as results rather than silently prepopulating a first-use workspace.

Genesis validity, module authorization, source/context authenticity, migrations and physical host command execution are either explicitly demonstrated or excluded assumptions. Historical computation validity does not establish fresh authorization.

## 6. Retention and availability matrix

| Promised operation | Required retained/available information |
|---|---|
| State reconstruction | Exact accepted genesis/anchor plus ordered committed deltas and applicable declarations; lifetime metadata where operational reconstruction is promised |
| Execution re-evaluation | Applicable module/profile, exact operational parent and original request/context/input observations |
| Command replay | Canonical ordered event occurrences, payloads and multiplicity, linked to exact history |
| Full audit export | Complete support that reconstructs all promised facts, memberships, traces and record fields |
| Independent proof check | Proof, trusted/reconstructed parameters, expected exact claim and mandatory bridge support |

Commitment/proof validity does not make data retrievable. Missing/corrupt support is an explicit availability failure, not proof of invalid computation. No arbitrary code from an evidence package may execute. Bound decoding, lengths, decompression and artifact sizes, and report resource failures separately from invalid proofs.
