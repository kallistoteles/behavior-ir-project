# Known Issues

Cross-repository findings and their resolution history. Each entry names the owning
repository: implementation and acceptance belong there, following its constitution
and Spec Kit flow. GitHub issues are the owning trackers; this file is an index and
historical explanation, not a semantic authority.

**Status checked:** 2026-10-17. Both Core and the ecosystem currently list no open
GitHub issues. This is a tracker snapshot, not a declaration of defect freedom or
feature completeness. Source fixes and published package availability are distinct:
the ecosystem's Core 0.15.0 adoption is merged, while its next package release is
still being prepared. See the [current baseline](README.md#current-baseline).

## KI-001: Module source locations depend on the checkout path, and notebook builds crash

| | |
| --- | --- |
| **Status** | Resolved on ecosystem main. Core normalization is published in 0.14.0 and later, and adopted by ecosystem 508. Ecosystem package delivery is pending release 509. |
| **Found** | 2026-10-12, behavior-ir feature 501 (Behavior Models), convergence task T076; refined 2026-10-15 by review |
| **Owner** | behavior-ir: Python source collection; behavior-ir-core: final-IR source normalization. |
| **Original severity** | Medium for notebook/REPL crashes; low for diagnostic location drift. Semantic hashes are unaffected, but source provenance can affect fresh legacy read-record identities. |

### Resolution and current contract

- [Ecosystem #19](https://github.com/kallistoteles/behavior-ir/issues/19) was closed
  by [PR #22](https://github.com/kallistoteles/behavior-ir/pull/22): enum locations
  come from their definition, missing files no longer crash notebook builds, and
  virtual markers remain verbatim.
- [Core #31](https://github.com/kallistoteles/behavior-ir-core/issues/31) was closed
  by feature 027, released in [Core 0.14.0](https://github.com/kallistoteles/behavior-ir-core/releases/tag/v0.14.0).
  `finish` and `admit_read` normalize locations from the final IR. Only absolute
  paths contribute to an inferred absolute root; relative paths and virtual
  markers remain verbatim. See the [source-location contract](https://github.com/kallistoteles/behavior-ir-core/blob/v0.15.0/docs/source-locations.md).
- [Ecosystem 508](https://github.com/kallistoteles/behavior-ir/pull/26) adopts Core
  0.15.0. Its [implementation evidence](https://github.com/kallistoteles/behavior-ir/blob/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5/specs/508-core-release-0-15/implementation-log.md)
  records all three former Core #31 strict xfails as ordinary passing tests.

BehaviorHash, SchemaHash and query meaning are preserved. Corrected provenance
can change newly constructed legacy read identities; historical bytes and
recorded-profile replay are not rewritten. The current resolution supersedes
the proposed workarounds below.

### Historical finding

The following diagnosis and proposals describe the pre-fix implementation. They
are retained as the finding's history, not instructions for current development.

### Symptom

1. **Location drift.** The same Python model, built from two different checkout directories (or
   from two working directories), yields admitted modules whose source locations differ. They
   differ in the wire JSON (`to_wire_json`), in admission diagnostics, and in anything else that
   shows `loc`. For example, `tmp/one/checkout/machine.py` versus
   `ci/build/elsewhere/machine.py`, where both should read `machine.py`. BehaviorHash and
   semantic item hashes are identical. The later Core #31 investigation also established
   that source locations could affect legacy ad-hoc read-record identity.
2. **Crash.** A model that uses an enum, defined in a notebook cell or a REPL (a `__main__`
   without `__file__`), cannot be built: `OSError: source code not available` escapes from the
   binding.

### Root cause

The fault is in the ecosystem's Python binding, not in Core. Locations come from two places,
and both can produce something other than an absolute path to a real file.

1. **Enum locations.** `behavior.types.enum_type` (`python/behavior/types.py`) derives an enum's
   location as `(inspect.getfile(cls), cls.__firstlineno__)` and catches only `TypeError` and
   `AttributeError`. On Python 3.13, `inspect.getfile` behaves in three ways:
   - the class's module is not in `sys.modules` (for example, loaded with
     `importlib.util.spec_from_file_location` without registration, or `exec`'d into a
     namespace with an unregistered `__name__`): `TypeError`, caught, so `loc` is `None`;
   - the class is in `__main__` and `__main__` has no `__file__` (a notebook cell, a REPL):
     `OSError`, **not caught**, so building the module crashes (symptom 2);
   - `__main__.__file__` is a pseudo-filename, such as `<stdin>` for `python - < machine.py`: it
     is returned as the location, a relative path.

   When `loc` is `None`, `CompileSession.declare` (`python/behavior/module.py`) substitutes the
   relative placeholder `("<unknown>", 1)`.
2. **Every other location.** `behavior.location.caller_loc` (`python/behavior/location.py`)
   returns `os.path.abspath(frame.f_code.co_filename)`. For `exec`'d or compiled code the
   filename is a pseudo-filename such as `<string>`, so the location becomes
   `<current working directory>/<string>`: an absolute path that encodes the working directory.
   When no frame outside the package exists, it falls back to the relative `("<unknown>", 0)`.
3. **Relativization.** Core's `Builder::finish` relativizes every location to `root`, or, when no
   `root` is given, to the common directory of all location files (`common_dir` in
   `crates/behavior-core/src/builder.rs`). Any non-absolute entry (`<unknown>`, `<stdin>` or
   another pseudo-filename) makes that common directory empty, so every absolute path keeps all
   its components. A working-directory-based path from step 2 likewise keeps the working
   directory. Either way, the module's locations encode the checkout path or the working
   directory (symptom 1).

This describes the old relativization behavior. The current contract separates absolute
paths, relative paths and virtual markers as described in the resolution above.

Reproduction (in `../behaviour-ir`, inside `nix develop`):

- **Drift.** Copy `models/examples/state_machine/machine.py` into two temporary directories,
  load each copy with `spec_from_file_location` **without** registering it in `sys.modules`,
  build `module()`, and compare the distinct `loc.file` values in the two wire JSON documents.
  They are `<unknown>` plus a checkout-dependent path, and they differ. Normal imports do not
  reproduce it: with every file absolute, the common directory relativizes correctly.
- **Crash.** Create a fresh `types.ModuleType("__main__")` without `__file__`, install it as
  `sys.modules["__main__"]`, and `exec` into its namespace a module that declares an enum
  `Status` and an entity with a `Status` field, then builds a `BehaviorModule`. The build raises
  `OSError: source code not available`.

### Historical workaround

Pass an explicit build root, `BehaviorModule(..., root=<project directory>)`. Core then strips
that prefix from every absolute location and leaves placeholders as they are, so the locations
no longer depend on the checkout. This does not help with `exec`'d code (its locations are
based on the working directory, not the project) or with the crash.

### Earlier mitigation (feature 501)

Behavior Model receipts are not affected. Since feature 501 (T076), source-map locations in a
`LoweringReceipt` are relative to the build `root`, or else to the common directory of the
model's own sources. The receipts are identical across checkouts, and tests in both Rust and
Python prove it.

### Historical proposed fixes

- **behavior-ir (root cause).** A `fix/<topic>` branch; no Core change is needed.
  - `enum_type` must never raise for a missing location: catch `OSError` as well.
  - A location is either an absolute path to a real file or an explicit non-path marker, never
    a pseudo-filename passed through `abspath`. `caller_loc` keeps pseudo-filenames (`<string>`,
    `<stdin>`, `<cell>` and the like) verbatim instead of resolving them against the working
    directory, and `enum_type` treats a pseudo-filename from `inspect.getfile` the same way.
  - An enum's file and line come from one source, the class's definition: the file of the
    defining module (`sys.modules[cls.__module__].__file__`, when it is a real file) and
    `cls.__firstlineno__`. Do **not** take the file from the caller's frame. `enum_type` is
    cached on first use, which can be a field annotation in another file, so the caller's file
    and `__firstlineno__` would describe different code. When no defining file exists, use a
    marker naming the module (for example `<__main__>`) with `__firstlineno__`.
  - Markers must not leak into the relativization: when `root` is not given, compute it in the
    binding as the common directory of the absolute, real location files only, and pass it to
    `Builder::finish`. Markers then stay as they are, and real files become
    checkout-independent.
  - Regression tests, each of which fails before the fix:
    - build the same module from two checkout directories, loaded **without** registering it
      in `sys.modules`, and compare the wire JSON byte for byte;
    - build the same `exec`'d module from two working directories and compare the wire JSON;
    - build a module with an enum from a `__main__` without `__file__` (the notebook case) and
      from `<stdin>`, without an exception.
- **behavior-ir-core (optional hardening, low priority).** When `Builder::finish` computes the
  common directory, it could ignore every non-absolute location file, not only placeholders
  (`<unknown>`, `<stdin>` and other pseudo-filenames), or report them. Source locations are
  outside semantics, so this is diagnostics quality, not semantic necessity. It should be
  proposed as its own Core change after the current Core feature work, never folded into an
  unrelated Core branch.

## Other resolved Core findings

| Finding | Delivery and current status |
| --- | --- |
| [#21 — Ordinary Facts/witness schemas](https://github.com/kallistoteles/behavior-ir-core/issues/21) and [#24 — query-bearing candidate evidence](https://github.com/kallistoteles/behavior-ir-core/issues/24) | Closed; corrected in the Core 0.13.0 line. Ordinary Facts and Bundle Evidence retain distinct strict contracts; required query-result integrity remains enforced. |
| [#29 — incomplete binding parent snapshots](https://github.com/kallistoteles/behavior-ir-core/issues/29) | Closed; feature 026 shipped in Core 0.14.0. Ecosystem 508 removes private snapshot completion and executes all ten published current binding requests unchanged. |
| [#35 — query-summary incongruence](https://github.com/kallistoteles/behavior-ir-core/issues/35) | Closed; feature 028 shipped in Core 0.15.0 with verifier 0.10.0. Ecosystem 508 proves the unchanged C19 module; the 506 full report now has 39 passes and no blockers. |

The [508 evidence comparison](https://github.com/kallistoteles/behavior-ir/blob/3f28bdebc3ba72e96e0c85e7a3bf2b087a5dddf5/specs/508-core-release-0-15/evidence/verification-comparison.md)
records the adopted pin, removed workarounds and conformance results. Historical
reports that show the old blockers remain historical evidence, not current status.
The remaining durable-integration and developer-acceptance work is tracked in the
[roadmap](FEATURE-COMPLETENESS.md), rather than classified as a newly discovered Core bug.
