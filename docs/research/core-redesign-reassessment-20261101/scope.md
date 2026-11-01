# Core architecture: end-to-end correctness and absolute latency

2026-11-01. User clarification supersedes the previous choice of investigation
scope. The objective is to discover a better computational architecture, with
millisecond-scale targets, rather than treat a compatible optimization patch as
the final solution. The user's two-minute example is illustrative, not a new
measured baseline.

## One chain, three required stages

Initialization, ordinary transitions and independent historical verification
all belong to the correctness and cost investigation. Selecting only the warm
transaction path does not answer the question. Moving expensive work to startup,
a proof producer, background processing or a later auditor does not establish
an end-to-end improvement.

For every expensive operation, record:

1. The exact mathematical statement and observations it must establish.
2. The inputs, prior established facts and trust/availability premises it needs.
3. The current algorithm and the source/measured reason for its cost.
4. Which cost is required by the claim and which arises from the representation,
   repeated work or chosen algorithm.
5. An established researched alternative, its theorem and the missing Core
   correspondence obligations.
6. Initialization, update, proof production, independent checking, recovery and
   export costs, including absolute times and complete-workflow totals.

The proposed correctness structure is checked initialization of exact semantic
views, preservation by exact transitions, and composition binding the same
initial state, requests, context, module/profile versions, outcomes, history and
command occurrences. This is an obligation to discharge, not an already-proved
theorem about a new Core implementation. Invariant preservation alone is weaker
than exact execution. Cryptographic commitments alone do not prove query
completeness or data availability.

## What the existing work establishes

The [published compatibility study](../core-final-investigation-20261031/report.md)
measured real improvements within the existing full-record contract. Its sealed
artifacts remain unchanged. It does **not** settle this architectural objective;
its patch and relative gains are evidence about the existing design.

The earlier first-principles work already proposed maintained exact views,
semantic witness checking and incremental compilation. Core032's maintained
prototype still recomputed full view meaning and co-checked against full Core;
its independent checker replayed the history. Its shared DAG still constructed
and expanded full outputs. Its Nova prototype still required a full Core replay
bridge and did not implement compressed proof verification. Those measured
prototypes therefore do not establish the cost of a genuinely incremental
end-to-end engine. See [the source-backed reassessment](prior-design-evidence.md).

## Research leads and limits

There is existing formal research for replacing repeated computation:
[DBSP](https://www.vldb.org/pvldb/vol16/p1601-budiu.pdf) derives incremental
relational computations with a machine-checked mathematical theory, and
[the incremental lambda calculus](https://inc-lc.github.io/resources/pldi14-ilc-author-final.pdf)
proves differentiation conditional on its primitive/change interface. These
results do not automatically prove Core's checked arithmetic, lazy evaluation,
selected first error or ordered observations. A translation and primitive
correspondence must carry those meanings through.

[Authenticated index research](https://www.cs.bu.edu/~reyzin/auth-db.html)
addresses authenticated query results and completeness for particular query
classes. [Nova](https://github.com/microsoft/Nova) addresses accumulated
computation proofs. Neither replaces the semantic relation, initialization or
retained-data contract. Their applicable costs and assumptions must be compared
within the same complete chain, not advertised as free components.

A concrete candidate is a compiled, order/error-aware change program maintaining
exact semantic state and versioned evidence. Its work should follow actual
affected dependencies where justified, rather than routinely rebuilding all
state and history. Complete audit reconstruction remains a requirement. This
candidate was proposed earlier; it is not a newly discovered or currently
validated solution. [Researched alternatives](researched-alternatives.md) records
the primary-source methods and their remaining obligations.

No millisecond result or general Core correctness theorem has been established
for that candidate. Large new inputs, wide affected dependencies and explicitly
requested large outputs require honest work accounting. Such limits must be
derived from the actual claim and access model, rather than assumed from the
current JSON implementation. The architectural investigation remains open.
