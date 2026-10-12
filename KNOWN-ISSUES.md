# Known Issues

Cross-repository issues that are known but not yet fixed. Each entry names the owning
repository: the fix belongs there, following that repository's constitution and Spec Kit flow.
This file records the finding; it is not a semantic authority.

## KI-001: Module source locations depend on the checkout path

| | |
| --- | --- |
| **Status** | Open |
| **Found** | 2026-10-12, behavior-ir feature 501 (Behavior Models), convergence task T076 |
| **Owner** | behavior-ir (root cause); behavior-ir-core (optional hardening) |
| **Severity** | Low: non-semantic. No hash, decision or replay result is affected |

### Symptom

The same Python model, built from two different checkout directories, yields admitted modules
whose source locations differ. They differ in the wire JSON (`to_wire_json`), in admission
diagnostics, and in anything else that shows `loc`. For example, `tmp/one/checkout/machine.py`
versus `ci/build/elsewhere/machine.py`, where both should read `machine.py`. BehaviorHash, item
hashes and records are identical, because locations are never hashed.

### Root cause

The fault is in the ecosystem's Python binding, not in Core.

1. `behavior.types.enum_type` derives an enum's location with `inspect.getfile(cls)`. That
   works only when the defining module is registered in `sys.modules`. A module loaded with
   `importlib.util.spec_from_file_location` without registration, code run through `exec`, or a
   notebook cell gives no location, so the enum's `loc` is `None`.
2. `CompileSession.declare` (`python/behavior/module.py`) then substitutes the relative
   placeholder `("<unknown>", 1)`.
3. Core's `Builder::finish` relativizes every location to the common directory of all files.
   One relative entry (`<unknown>`) makes that common directory empty, so every absolute path
   keeps its components. The module's locations then encode the checkout path.

Core behaves as designed. Its relativization only assumes that locations are comparable paths.

Reproduction (in `../behaviour-ir`, inside `nix develop`): copy
`models/examples/state_machine/machine.py` into any temporary directory, load it with
`spec_from_file_location` without registering it in `sys.modules`, build `module()`, and list
the distinct `loc.file` values in its wire JSON. They are `<unknown>` and a checkout-dependent
path.

### Already mitigated

Behavior Model receipts are not affected. Since feature 501 (T076), source-map locations in a
`LoweringReceipt` are relative to the build `root`, or else to the common directory of the
model's own sources. The receipts are identical across checkouts, and tests in both Rust and
Python prove it.

### Proposed fixes

- **behavior-ir (root cause).** Never mix a relative placeholder into absolute locations. Either
  derive a missing enum location from the first field or parameter that uses the enum, or
  resolve `inspect.getfile` fallbacks through the class's `__module__` and `__firstlineno__`
  together with the caller's frame. Add a test that builds the same module from two checkout
  directories and compares the wire JSON byte for byte. This is an ecosystem bug fix (a
  `fix/<topic>` branch), and no Core change is needed.
- **behavior-ir-core (optional hardening, low priority).** `Builder::finish` could ignore
  non-absolute placeholder files when it computes the common directory, or report them. Source
  locations are outside semantics, so this is diagnostics quality, not semantic necessity. It
  should be proposed as its own Core change after the current Core feature work, never folded
  into an unrelated Core branch.
