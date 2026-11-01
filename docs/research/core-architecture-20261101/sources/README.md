# Selected Core primary-source snapshot

This directory preserves 32 selected reports, contracts and source files cited
by the architecture work. Total source bytes: **564,582**. Each file is copied
byte-for-byte from the retained Core checkout at
`1a3ae37623cf90b4608a678ef283ee313306d9bb`; all 32 also match the corresponding
committed Git blob. The [manifest](manifest.json) records path, size, SHA-256
and per-file equality to that checkout commit.

This is a partial source snapshot for reading, not a runnable Core checkout, new
measurement campaign or proof audit. Relative links inside copied originals are
preserved verbatim and may refer to material outside this selected subset.
Architecture/candidate links point directly to preserved files. Later project-side
measurements remain in their existing research directories.

Useful entry points:

- [029 evaluation](core/specs/029-incremental-global-validation/evaluation-report.md)
  and [correctness](core/specs/029-incremental-global-validation/correctness.md).
- [031 investigation](core/specs/031-scalable-execution-evidence/investigation.md),
  [single-create profile](core/specs/031-scalable-execution-evidence/profiling/single-create-20261028/report.md),
  [first principles](core/specs/031-scalable-execution-evidence/profiling/first-principles-20261028/research.md)
  and [greenfield](core/specs/031-scalable-execution-evidence/profiling/greenfield-redesign-20261028/research.md).
- [032 investigation](core/specs/032-transition-verification-study/investigation.md),
  [cost model](core/specs/032-transition-verification-study/evidence/cost-model.md),
  [correspondence](core/specs/032-transition-verification-study/evidence/correspondence.md)
  and [circuit correspondence](core/specs/032-transition-verification-study/evidence/circuit-correspondence.md).
