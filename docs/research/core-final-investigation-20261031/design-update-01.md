# Typed-view scope clarification before implementation/measurement

The initial design named record JSON as the borrowed leaf. Source inspection
establishes the same infallible Value-to-Value-copy premise for `read_facts` and
the Some payload of `authorization_context`. The final typed-view arm borrows
all three, retaining exact null/None omission distinctions. Other fields still
use the existing to_value conversion in derive declaration order. No timings
were used to choose this extension.

The existing v2 governance candidate constructs its owned content JSON, then
passes that Value through generic hash_of, copying it again. The final arm
reuses that already materialized content through a private hash_json helper.
Generic hash_of still performs its original arbitrary-Serialize conversion
before calling this helper; no generic map-reduction, integer-range or custom
serialization behavior is bypassed. The candidate's owned content construction,
semantic validation and later independent checks remain. Core retains canonical
validation, root projection, serialization and digest authority.

The final comparison includes the narrower Core-streaming arm separately, so
its result does not conceal this broader materialization change. Migration
event hashing retains the former generic path. This clarification precedes
runtime implementation and all measured campaign freezes.
