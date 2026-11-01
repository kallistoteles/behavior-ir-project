# Disposition of an additional v2-only reuse opportunity

The source audit in `local-reuse-audit.md` identifies one additional repeatable
operation: a freshly archived v2 action bundle is hashed once before event
construction and again during the event's kind/history checks. The v1 fixture
does not contain this repeated nested hash. This is a plausible future candidate,
not a measured gain or a required validation phase that can simply be deleted.

The final candidate retains both calls. Removing one correctly would require a
new consuming owner-bound factory and a second private route through event
validation. That route needs a separate set of ownership, mutation, error-order,
retry and backend controls. A reusable hash cache or caller-supplied proof would
not establish the same-owner premise. These changes add a validation interface
for a v2-specific benefit, whereas this study's retained hashing changes use the
existing complete validation boundaries in both versions.

This is a maintenance/scope decision, not an empirical rejection: no experiment
has established the factory's performance, and this study does not claim that
the retained solution is the fastest possible implementation. Its remaining
cost is explicitly classified as known repeated contract checking with a
source-justified, unadopted reuse design. It is not used to explain the earlier
v1 first-serialization regression. Public/backend/replay/recovery hashing and
their independent checks remain complete in the measured final candidate.
