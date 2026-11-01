# Final Core investigation protocol

Prepared 2026-10-31 before final-candidate implementation and measurements.
Scope: performance under the existing complete decision/evidence/history contract.
No compact record format, skipped validation, weakened governance, or new facade
surface is authorized by this protocol. Earlier studies remain immutable.

## Completion criteria

1. Investigate remaining canonical/document materialization with source-backed
   correspondence arguments; implement and retain only justified candidates.
2. Distinguish the first-serialization output-sink, buffer-growth and object-history
   factors with fresh-process controls. Operational mitigation may be established
   without claiming unsupported CPU/cache/allocator causation.
3. Compare the combined solution with prior reference stages in one fresh campaign,
   covering native phases, serialization and complete observable outputs.
4. Run the owning repository gates on a clean candidate checkout, address actual
   regressions, and record any external prerequisite that prevents a gate.
5. Produce one consolidated solution, patch, reproduction recipe and recommendation,
   with remaining costs classified as contract work, deliberately retained generic
   semantics, rejected optimizations or empirically unresolved mechanisms.

## Candidate design and constitution check

Start from guarded typed-record C plus archived-bundle ownership transfer.
First test buffered canonical JSON streaming into SHA-256, preserving complete
float validation and exclusion of only a top-level hash. Preserve the existing
canonical-string API and generic Store hash_of semantics.

Then test a Core-owned borrowed document view: borrowed/owned JSON leaves and
sorted object composition, one authoritative validator/projection/serializer/hash.
Store may construct private views for CommitBundle and TransitionRecord only,
matching existing derive declaration evaluation order and omission predicates.
Borrow only already-owned record JSON; materialize small fields with the existing
serde_json::to_value conversion, retaining its exact success/error semantics.
Nested bundle serialization must not introduce new semantic bundle validation.
Retain independent Store/backend checks and migration fallbacks.

Tests precede runtime changes: resource-goal red plus hash/error/reference
conformance, including excluded metadata floats, nested hash content, Unicode,
integer boundaries, declaration versus canonical key order, v1/v2 action and
migration products, and compound errors. Known typed views require a complete
field/attribute inventory and differential tests against frozen old hash methods.
No unsafe code or new dependencies. Internal implementation types are not
re-exported through the supported behavior-engine facade.

## Serialization factors

Use unchanged actual evaluate/commit and fixed expected decision bytes. Each
fresh process selects one sink, with its first original call before parsing or
equality traversal, then repeated original and fresh-parsed calls. Compare:
Display Value::to_string; serde_json::to_vec; direct to_writer with initial
capacity128; direct to_writer with capacity equal to expected bytes. Report setup,
write and within-call sum separately where allocation is outside the write timer.
Keep outputs alive through byte checks after timing, then drop before next call.
Controls separate sink path and capacity; do not attribute to_vec differences to
allocation alone. If needed, matched Display output buffers and allocation-free
object-touch controls discriminate remaining hypotheses. Prespecify each stage
before collecting it and retain all adverse/negative observations.

## Shared evidence rules

Freeze exact case matrices, source, binary, collector and control identities
before each measured stage. Run one child at a time on CPU7 with8GiB address-space
limit and180-second timeout after builds/tests stop. Preserve every attempted
command, explicit mode/env, stdout/stderr and status, including handled failure,
timeout and interruption. Incomplete data cannot be Complete. Compare entire
bytes, exact error variants/messages and complete history/replay observations;
retain representative gzip artifacts. Derive phase sums within a sample before
medians; report paired regressions and process totals separately. No benchmark
selection, naive diagnostic subtraction or cumulative ratios across old studies.

Final gate and campaign matrices are appended in separate frozen stage manifests
once sources/controls are ready; this design protocol does not predict wins.
