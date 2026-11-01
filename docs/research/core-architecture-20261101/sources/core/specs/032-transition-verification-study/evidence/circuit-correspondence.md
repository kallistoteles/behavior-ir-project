# Bounded circuit correspondence

This is conditional exact-computation evidence, not a proof that arbitrary Core
programs or the Rust extractor/compiler are formally verified.

The concrete circuit supports C=1..16 live children, a fixed catalog of 2C
lifetime identities, one row per create/set/remove, positive signed-64-bit x,
constant padding, no references, constant command payloads and 0..16 duplicate
occurrences. Operations are create, literal set, remove, emit and a captured
threshold count. Add/lazy, parent relationships, batches and out-of-catalog IDs
fail Unsupported before proving; the native reference supports its wider declared
fragment. The complete module inventory is still bound even when a proof covers
only this supported execution prefix. No guarantee about unexecuted actions is
inferred from a prefix proof.

| Claim | Evidence | Remaining trust |
|---|---|---|
| Exact module/schema/profile/configuration | Core admission and regenerated complete template; source-based subject SHA | Core admission/hash correctness and SHA256 collision resistance |
| Initial state and lifetime IDs | Actual history-bound Core snapshot and complete prefix; every slot compared to independently reconstructed state | Core/backend completeness; Rust extraction |
| Identity encoding | Catalog is JSON encoded and SHA256 bound; indexes range checked and exactly one selected | JSON/circuit translation and hash assumptions |
| State transition | R1CS Boolean/range/selection constraints and actual Core comparison at every step; wrong-but-positive outputs fail | Rust R1CS construction; correspondence to logical F is reviewed/tested, not machine extracted |
| Attempts/commits | Every attempt increments; successful operations alone increment commits; source/target counters constrained to u64 | Counter interpretation in adapter |
| Commands | Complete constant canonical bag determined by admitted module; occurrences counted with multiplicity; command-only commits retain distinct history | Core canonical renderer and model binding |
| Attempt commitment | Fixed domain tag; previous 32 bytes; 8-bit opcode; u32 LE identity; three signed i64 LE inputs; outcome byte; u32 LE command count | SHA gadget and SHA256 collision resistance |
| Full digest | Two range-checked 128-bit limbs; actual one-field modulus collision control; `two_limbs_injective` | Correct Boolean-to-limb/SHA translation; no truncation permitted |
| History composition | `history_exact`, `no_unchecked_suffix`, `bounded_step_exact`; checked Lean theorem/axiom/fresh-kernel reports | These concern the declared mathematical relation, not a mechanically verified translation of R1CS |
| Accumulation | Real Nova RecursiveSNARK on Pallas/Vesta with Pedersen commitments; expected z0, exact steps and returned final state checked independently. IPA/Spartan types supply setup floor hints; no compressed proof is constructed | Nova soundness/Fiat–Shamir/Pasta assumptions and unverified cryptographic implementation |
| Existing Core identity | Entire exact operation sequence replayed with ordinary Core; full observations, command outputs, StateIds and HistoryRefs bound | Core implementation; full O(history × live/evidence work) bridge cost remains |

The 256-bit attempt hash is carried in the circuit. Core's MuHash and canonical
history hashing are **not** computed in it. Combined acceptance requires a valid
accumulated proof plus the independently reconstructed exact Core observations.
A fast folding check is not succinct independent verification of the full Core
history while this bridge remains necessary.

`RecursiveSNARK::new` constructs the initial step; the first `prove_step` finalizes
its accounting. A near-zero first `prove_step` timing does not mean the first step
was free. Whole producer timing includes initialization. Early reports do not
separately instrument every initialization subphase; missing detail must remain
unmeasured rather than inferred by subtracting phase medians.

The x86 upstream default enabled ADX/BMI2 assembly unsupported by this host.
An archived Cargo-only overlay selects the library's existing portable arithmetic.
The crypto source is otherwise the pinned upstream tree. This is a distinct
reproducible tool identity, not an unmodified-default performance claim.

Initial validity, snapshot provenance, authorization of the module and context,
migrations, physical command execution, retained data availability and proof
translation correctness remain separate explicit obligations. A proof artifact
adds no Core business state, events or replay requirements.


The selected IPA/Spartan types are used for `ck_floor()` parameter-size hints. The actual retained artifact is `RecursiveSNARK`, whose verification checks the accumulated relation. It is not a produced or verified `CompressedSNARK` or a measured Spartan/IPA final-proof run. The parameter recipe records the selected configuration family; this distinction changes no existing recipe, binary or proof bytes.
