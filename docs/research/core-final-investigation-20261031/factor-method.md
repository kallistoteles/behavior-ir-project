# Matched Display capacity and read-only input intervention

Prespecified2026-11-01 after all550 primary processes passed verification,
before collecting any follow-up sample. No runtime source or executable changes.

## Selection and hypotheses

The primary N512 legacy C/A growing-sink gap is10.35% for Display,12.19% for
to_vec and14.24% for writer128, versus-0.17% for writer-full. This implicates
buffer-growth/output-path interactions within that probe, without isolating
Display's own buffer capacity. Exact historical anchors still show C/A first
Display regressions of12.01% atN128 and5.84% atN512. The final candidate is
faster in those anchors. Separately, final/original native N128 command-v2
Display is25.67% slower (all7pairs), despite22.06% faster evaluate+commit+
serialization. This adverse phase requires direct follow-up rather than being
hidden by a larger commit gain.

The primary writer-full setup medians atN512 are3.1587ms(decode),3.1503ms(typed),
0.7610ms(moved) and0.1208ms(view), while first write medians are1.2021,
1.2107,1.2253 and1.2130ms. Thus much of the broad first-call difference is
already localized to the presized allocation/setup interval, before JSON
traversal. This is stronger evidence than a total-sink comparison, but it
does not identify an allocator routine, kernel path or physical cause.

H1: if output-buffer growth explains the C/A gap, a matched Display path with
full observed capacity should narrow it versus Display128. Full capacity is
asserted unchanged; setup allocation remains charged in total.
H2: if original input-tree history contributes, a read-only allocation-free walk
before O1 can change the gap even with a presized sink. A changed gap supports
an input-history intervention effect, not unique cache/TLB/allocator attribution.
H3: direct writer versus Display at full capacity tests the output adapter path
while both buffers avoid growth. It does not isolate allocation alone.
H4 tests the specific hypothesis that the broad arm difference persists in the
full-capacity pre-write preparation interval after the allocation-free input
touch. This interval includes dispatch, allocation, capacity inspection and the
clock call; it is not isolated allocator routine time. The walk may reduce
later traversal cost, but can also change metadata/cache residency or frequency/
scheduling and therefore affect preparation despite making no heap calls.
Persistence would support this specific hypothesis, not prove every allocation-
history explanation. A total reduction without a setup change must not be
described as eliminating allocation work.

The source permits different allocation/address/code/cache histories; logically
equal original and fresh-parsed Values are not a promise of identical physical
layout or cold hardware state. Both positive and negative interventions count.

## Exact matrix and observations

N128/N512 legacy: decode, typed, view. N128/N512 command-v2: original, view.
Each arm/case has Display, Display128, Display-full and writer-full, crossed
with sham/read-only-touch, seven fresh processes per cell:560processes,
4,480Rust serialization rounds,80representative complete outputs. Order uses
cyclic rotations with direction independent of repetition; all arm positions
occur. Executed aliases, source and binaries are the unchanged frozen primary
ones. Expected bytes are the same original oracles.

The Rust walk reads container lengths, object keys, strings and scalar values;
its live checksum prevents removal and the existing control checks immutability.
It applies only before original O1. Sham still executes the same surrounding
clock/checksum scaffolding. All eight actual outputs are compared to frozen
bytes after each timer. One actual O1 copy, drops, parsing and equality checks
retain the primary probe's order.

Report O1 and P1, within-process repeat medians, setup/write/total, every adverse
pair, and first-consumer=evaluate+commit+touch+O1total. Touch is never free in an
operational recommendation; whole process includes all rounds and parsing.
Do not merge these samples with primary cohorts or select faster individual
observations. The new manifest freezes the complete ordered matrix and method,
collector/control/analysis sources plus completed primary summaries. Existing
source/binary/oracle identities remain bound through the primary freeze digest.
Run after primary collectors stop, one child at a time, CPU7/8GiB/180seconds.
Keep failures, retain all adverse results, and verify the whole stage before
interpretation. Phase PMU diagnosis remains conditional; no hardware-cause claim
is licensed by this matrix alone.
