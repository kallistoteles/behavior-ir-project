# Accumulated proof lifecycle

The early C1/H2 experiment has three fresh producer and three fresh consumer runs
in each of first-use and reuse mode. Frozen manifests, sources, executables,
parameter provenance and all raw logs are in `proof-smoke/`. Consumer first-use
independently derives the parameters; reuse loads the exact consumer-derived
artifact and validates bytes, recipe and parameter identity. Every consumer
rechecks the new proof and exact Core bridge. Prior approval never replaces it.

The artifact is a transparent Nova recursive proof, not a compressed succinct
SNARK. IPA/Spartan types supply setup floor hints only; no compressed final proof is produced or verified. Compression: **NotImplemented**. No compression setup/key/size/time benefit
is claimed. Recursive proof bytes and transported container bytes are recorded
separately from the stable semantic claim. Timings and randomized proof bytes do
not enter the semantic claim identity.

Checkpoint continuation verifies the exact previous segment, its complete claim,
parameter recipe, content hash and actual committed history before adding steps.
Changing shape, genesis, operation prefix or module is rejected. Fresh final
verification is required for the extended proof. Checkpoints are disposable build
artifacts; losing one cannot change Core state or block ordinary Core replay.

Publication uses create-only local hard-link publication after a fully written,
fsynced staging file; interrupted/partial staging files cannot become accepted
checkpoints. This is a cooperating local-filesystem experiment, not a universal
power-loss/device or Store-backend guarantee.

Native, source-reported `proved`, and bridged coordinates denote committed history positions. The live `proved` counter advances when a Nova fold is constructed; this is construction progress, not a newly independently accepted certificate. The previous verified checkpoint remains the accepted proof boundary until final `prover::verify` succeeds. Final reports are emitted only after that check. Analysis must distinguish folded progress from the independently verified prefix.

Attempt counts and circuit microsteps are separately recorded. A proof for a
prefix cannot authorize a pending suffix. Genesis/migration/module switches need
new explicit validation boundaries rather than inherited authorization.

Public consumer tests use only `behavior-engine`, and reproduce persisted-before-
acknowledgement recovery in another process, original-event retry without duplicate
commands, conflicting stale candidates, canonical duplicate occurrences, replay
and missing historical support. They introduce no new Core API or consumer
production dependency. Bounded asynchronous measurements remain a separate final
campaign obligation until actually collected.
