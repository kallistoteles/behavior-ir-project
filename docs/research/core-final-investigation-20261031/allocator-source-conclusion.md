# Allocation history: source and CPU-profile conclusion

2026-11-01. Read-only follow-up to the completed PMU stage. Inspected existing
final diagnostic data, the linked glibc derivation/patches and upstream primary
source. Local source/hash work ran on CPU6. No runtime source edits, builds,
tests, producer executions or new measurements were performed. Calibration
samples are not used as final evidence here.

The final diagnostic supplies an allocator-level explanation for much of the
broad pre-write cost: its slow allocation windows execute sampled work in
glibc fastbin consolidation and bin unlinking. This closes a useful mechanism
question without establishing a unique cache/DRAM cause or tracing every
earlier allocation that produced the heap state.

## Exact source correspondence

The linked libc is
`/nix/store/lm3pknxi0ipypy3lxh1wmm8wvvavdwrn-glibc-2.42-84/lib/libc.so.6`,
build ID `67802a55cff437269d8d9608af391b6f583fca73`, SHA256
`b8cb091b34bdd88f6902eebff8761f9ea306e6789b4ac4d06d4470c0d568c80c`.
The retained binary-context record binds the profiled executable identities,
allocation call/clock boundaries and resolved libc path.
[Binary context](pmu-binary-context.json).

Read-only `nix derivation show` identified its actual deriver as
`/nix/store/sayi2sas6kn7q181jy7ic8h8hy2jiqn7-glibc-2.42-84.drv`.
It names a GNU glibc 2.42 tarball plus the release-branch patch and Nix patches.
Pinned nixpkgs `6774f7bc253789b113a4f39285dc0fa100abeacc` declares version
2.42 with suffix -84 and this same patch arrangement. Its stale explanatory
comment mentioning -67 is not the final version authority.
[Pinned common.nix](https://github.com/NixOS/nixpkgs/blob/6774f7bc253789b113a4f39285dc0fa100abeacc/pkgs/development/libraries/glibc/common.nix#L53-L84),
[package overrides](https://github.com/NixOS/nixpkgs/blob/6774f7bc253789b113a4f39285dc0fa100abeacc/pkgs/development/libraries/glibc/default.nix).

Among the actual derivation patches, only
`/nix/store/f3xrdrys50y52ij1vg5lk6qdqpvqmf9r-2.42-master.patch` modifies
`malloc/malloc.c`; other malloc-directory changes concern its Makefile and
memusage shell script. The post-patch commands do not modify this C file.
The base tarball is not present locally; this review did not rebuild or
reconstruct the whole glibc tree.

The five malloc.c patch transitions end in Git blob prefix `1d5aa304d3`.
The upstream release commit
`8be3551ccb4e17e93ad82152de56d2c90de21f97` supplies malloc.c with full Git blob
`1d5aa304d3f38bdcaa4549d7c8d9cd336c6ef4b3` and SHA256
`6942efc76c8c6419d8eb8f5ca73698222422d1bf15e8dc34d61da1ea89275f89`
(201,638 bytes), computed from the retrieved primary source. Thus the cited
allocator implementation matches the terminal file in the actual package's
patch chain, rather than assuming an unpatched version tag is identical.
[Exact source commit](https://github.com/bminor/glibc/blob/8be3551ccb4e17e93ad82152de56d2c90de21f97/malloc/malloc.c),
[pinned release patch](https://github.com/NixOS/nixpkgs/blob/6774f7bc253789b113a4f39285dc0fa100abeacc/pkgs/development/libraries/glibc/2.42-master.patch),
[inspected local patch](/nix/store/f3xrdrys50y52ij1vg5lk6qdqpvqmf9r-2.42-master.patch).

## What the allocator routines do

Fastbins retain recently freed small chunks with deferred coalescing.
On its large-request path, `_int_malloc` checks `have_fastchunks` and can call
`malloc_consolidate` before normal bin processing. Consolidation drains fastbin
lists, merges adjacent free chunks and places results in the unsorted bin,
or merges them into the top chunk. It calls `unlink_chunk` when removing free
neighbors from existing bins. That helper checks chunk-size/list consistency,
repairs doubly linked bin pointers and, where applicable, size-ordered links.
[Large-request trigger](https://github.com/bminor/glibc/blob/8be3551ccb4e17e93ad82152de56d2c90de21f97/malloc/malloc.c#L4159-L4175),
[consolidation](https://github.com/bminor/glibc/blob/8be3551ccb4e17e93ad82152de56d2c90de21f97/malloc/malloc.c#L4928-L5023),
[unlinking](https://github.com/bminor/glibc/blob/8be3551ccb4e17e93ad82152de56d2c90de21f97/malloc/malloc.c#L1617-L1656).

Consequently, one large output-buffer reservation can pay deferred cleanup
for many previously freed small chunks. Which frees reach fastbins depends
on allocator state and caching paths; not every freed object joins them.
This supplies a concrete interpretation of work charged to a later
serialization setup. Consolidation is heap bookkeeping/coalescing, not a
CPU-cache flush or a JSON traversal. Source alone does not identify the
particular objects behind a sampled bin walk.
[Fastbin representation](https://github.com/bminor/glibc/blob/8be3551ccb4e17e93ad82152de56d2c90de21f97/malloc/malloc.c#L1719-L1738).

## Completed diagnostic evidence

The verified final stage has 105 measured processes, 70 stat runs and 35
sampling runs, with 105 complete equal-byte decisions. Both broad directional
allocation gaps reproduce in stat and sampling contexts. All recorded stat
event running percentages are 100%. These are separately built diagnostic
contexts, with control endpoints/expected bytes prepared before the fixture,
one enabled allocation region and later uncounted writing/verification.
[Verification](pmu-verification.json), [method](allocation-pmu-method.md).

Final **stat** allocation-window medians:

| Case / arm | Wall window ms | User cycles | User instructions | Later write ms |
| --- | ---: | ---: | ---: | ---: |
| N512 legacy A | 3.313231 | 9,286,001 | 8,477,366 | 1.113525 |
| N512 legacy C | 3.390235 | 9,565,213 | 8,466,455 | 1.123923 |
| N512 legacy V | 0.115205 | 350,368 | 231,992 | 1.118352 |
| N128 command-v2 original O | 0.046044 | 147,023 | 156,080 | 0.308275 |
| N128 command-v2 V | 0.410417 | 1,180,440 | 1,613,383 | 0.307985 |

The opposite case directions accompany substantially different executed user
instruction counts before writing; the later write medians remain close.
Empty-window wall medians are 0.000348–0.000386 ms, with 617 user instructions
and 11,240–12,681 user cycles. They characterize the scaffold and are not
subtracted from allocation medians. PMU enabled regions include acknowledgment
return, clocks and disable-tail instructions beyond the Instant interval.
[Stat groups](pmu-analysis.json).

Final **sampling** observations aggregated over seven fresh processes per cell:

| Case / arm | Window median ms | Parsed user-cycle samples | Identified sampled symbols |
| --- | ---: | ---: | --- |
| N512 legacy A | 4.163549 | 58 | 35 malloc_consolidate; 23 unlink_chunk.isra.0 |
| N512 legacy C | 4.267767 | 60 | 36 malloc_consolidate; 23 unlink_chunk.isra.0; 1 _int_malloc |
| N512 legacy V | 0.205441 | 1 | 1 _int_malloc |
| N128 command-v2 original O | 0.046483 | 0 | No sampled IPs |
| N128 command-v2 V | 0.610791 | 14 | 8 malloc_consolidate; 5 unlink_chunk.isra.0; 1 unknown |

This localizes the retained slow-window user-cycle samples to consolidation
and its bin-unlinking work in the exact linked libc. The `.isra.0` name is a
compiler-generated specialization; it remains function-IP attribution, not
a separately established source-level call count. The unknown sample remains
explicit. There are no unparsed sample lines; retained loss metadata reports
zero lost samples where present. Sparse/zero samples in faster cells do not
prove absence of those routines. Sampling perturbs the wall window; its
medians are not merged with stat or native results.
[Final sample groups and period weights](pmu-analysis.json),
[raw sample receipts](pmu/assessment.json).

## Supported final explanation and limits

The measured pre-write allocation path can perform deferred glibc fastbin
consolidation and bin unlinking, and the final slow-window profiles repeatedly
sample that work. Allocation/free history is therefore a supported mechanism
for the broad context-sensitive setup cost, beyond the earlier inference
from elapsed intervals alone. The V command-v2 N128 adverse setup direction
has the same sampled routine family as the slow A/C legacy N512 direction.
Removing copies can change the state and timing of later allocator work;
it does not promise monotonically faster first allocation in every case.

This does not fully explain the smaller historical **C/A growing-sink** gap.
In this full-capacity allocation diagnostic A and C both execute substantial
consolidation work, with similar stat windows and instruction counts. No
unique claim about the remaining C/A percentage, cache misses, DRAM latency,
TLB behavior, lock contention or frequency follows. Nor did this experiment
trace every earlier allocation/free to the exact final chunk lists or measure
the native Display instruction stream under identical instrumentation.

The complete-workload recommendation remains supported by the separate native
campaign: retain V, retain the explicit command-v2 N128 first-serialization
regression, and reject the tested preparatory touch after charging its cost.
The bounded allocator explanation makes those results coherent without
claiming every phase or every heap history improves. No forced allocator
cleanup or global allocator/tunable change is needed to state this conclusion.
[Operational evidence and adverse observations](serialization-conclusion-audit.md).
