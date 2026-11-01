# Final interpretation audit: one wording correction

2026-11-01. Read-only comparison of report.md with the verified primary,
factor and PMU results and the allocator source correspondence. No source or
frozen artifact edits, tests, builds, measurements or new experiments.

In the final disposition, replace:

> Exact full capacities come from benchmark oracles; production needs an already-available size hint.

with:

> Full capacities come from benchmark oracles. Reproducing the no-growth result requires an already available capacity bound sufficient for the output; an undersized hint can still grow. Charge any cost of obtaining or retaining that capacity to the caller's complete workflow.

The current phrase “size hint” could imply that any available approximate
hint reproduces the tested full-capacity result. The measured condition is
capacity at least the emitted byte length with no growth, and the oracle's
size-discovery cost is outside that experiment. This is a recommendation
qualification, not a defect in the retained measurements.
[Report disposition](report.md#final-disposition),
[full-capacity assertions and setup timer](serialization_factor.rs),
[within-V sink and complete-consumer contrasts](serialization-conclusion-audit.md).
