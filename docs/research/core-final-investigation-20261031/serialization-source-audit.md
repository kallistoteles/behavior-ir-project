# First post-commit serialization: source audit and decisive controls

2026-10-31. Research only: inspected the retained bundle checkout and prior
campaign artifacts; performed no runtime-source edits, builds or measurements.
The experiment below is a proposed discriminator, not a measured resolution.

## What is established

The residual campaign observed C/A N512 first-serialization median regressions
of 8.73–11.35%, with all 30 matched first-call pairs slower. Original repeats
and fresh-parsed medians improved. The bundle-move campaign observed M/C N512
first-serialization improvement of 32.14%, but did not measure A or repeat the
original/parsed controls. These campaign ratios cannot establish M/A behavior
or be multiplied into a cumulative gain. Both reports explicitly retain those
limits. [Residual evidence](../core-residual-profile-20261031/report.md),
[ownership evidence](../core-bundle-ownership-20261031/report.md).

Store returns a clone of `bundle.record`; final action assembly now moves the
owned archived bundle after computing its existing hash. The observed extra
serialization still operates on `evaluated.record`, not a newly serialized
typed record. The move changes temporary ownership history before this call.
[Returned Value](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/store.rs:1901),
[final assembly](/tmp/behavior-ir-core-bundle-20261031/crates/behavior-store/src/store.rs:2608),
[retained timer](../core-bundle-ownership-20261031/profile-driver.rs).

## Pinned serialization paths

The checkout pins serde_json 1.0.151, checksum
`c841b55ecdae098c80dcae9cf767f6f8a0c2cdb3416bbef72181df4d0fe73f14`.
The retained toolchain is rustc 1.98.1, commit
`48a229ceaefd4985c50990b14116b6d856af0985`.
[Lock](/tmp/behavior-ir-core-bundle-20261031/Cargo.lock:810),
[toolchain](../core-bundle-ownership-20261031/toolchain.log).

`value.to_string()` uses Rust's generic `ToString` implementation: create an
empty String, construct a formatter and invoke Display. `fmt::Write for String`
appends fragments using `push_str`. This starts with a different capacity policy
from serde_json's free function. [Pinned Rust source, ToString](https://github.com/rust-lang/rust/blob/48a229ceaefd4985c50990b14116b6d856af0985/library/alloc/src/string.rs#L2918-L2946),
[String writer](https://github.com/rust-lang/rust/blob/48a229ceaefd4985c50990b14116b6d856af0985/library/alloc/src/string.rs#L3369-L3380).

Value's Display wraps that formatter in `WriterFormatter`, an `io::Write`
adapter. Compact Display calls serde_json `to_writer`; each emitted UTF-8 byte
fragment is forwarded to the formatter's string writer. There is no memoized
serialized-byte result in this implementation.
[Pinned Value Display](https://github.com/serde-rs/json/blob/v1.0.151/src/value/mod.rs#L197-L255).

Value's Serialize implementation traverses its variants and each object's map
entries. It delegates arrays and scalars to their serializers. This same
implementation feeds either output sink.
[Pinned Value Serialize](https://github.com/serde-rs/json/blob/v1.0.151/src/value/ser.rs#L11-L36).

The free `serde_json::to_string(&value)` calls `to_vec`, then converts its Vec
to String without copying or validating UTF-8 again. `to_vec` creates a Vec with
capacity 128 and calls `to_writer`. `to_writer` creates a Serializer and invokes
Serialize. String escaping scans input bytes and emits runs/escapes through the
selected writer; punctuation also produces writes. Thus `to_vec` changes both
buffer policy and the Display adapter path. It is useful operationally but is
not an allocation-only experiment.
[Pinned entrypoints](https://github.com/serde-rs/json/blob/v1.0.151/src/ser.rs#L2177-L2256),
[fragment writes and escaping](https://github.com/serde-rs/json/blob/v1.0.151/src/ser.rs#L1734-L1780),
[escape scan](https://github.com/serde-rs/json/blob/v1.0.151/src/ser.rs#L2069-L2133).

Vec's I/O writer appends using `extend_from_slice`; it grows as necessary.
Holding its capacity at or above the final byte length removes output-buffer
growth from a successful equal-byte write. It does not remove traversal,
escaping, fragment dispatch, copying, or first writes to backing pages.
[Pinned Vec writer](https://github.com/rust-lang/rust/blob/48a229ceaefd4985c50990b14116b6d856af0985/library/std/src/io/impls.rs#L483-L527).

The available shared-cache serde_json fingerprints list only `default,std`;
the pinned map source therefore selects BTreeMap, without `preserve_order`.
Treat those fingerprints as supporting inspection, and retain the exact newly
built binary's dependency feature identity in the new campaign rather than
assuming any arbitrary cached file identifies it.
[Cached release fingerprint](/tmp/behavior-ir-core-continuation-20261029/target/release/.fingerprint/serde_json-6b646c32609bb236/lib-serde_json.json),
[map source](https://github.com/serde-rs/json/blob/v1.0.151/src/map.rs#L23-L36).

## Small staged design

### 1. Establish the actual operational result first

Measure A, C and M afresh in the same campaign, with the unchanged native
`evaluated.record.to_string()` boundary immediately after actual commit.
Use N512 as the primary discriminator and N128 as the nearby control; retain
the established population sweep for final consumer-level validation. Run
fresh sequential processes with rotated arm order, the same pinned toolchain,
lock, fixture, environment, CPU affinity and process limits. Retain at least
the prior ten paired repetitions at the primary populations, every attempt,
exact decisions, binary hashes and individual adverse observations.

Keep this native anchor separate from expanded diagnostics. The prior expanded
probe allocated its results Vec between commit and O1 and constructed a
schedule before evaluation; its report correctly discloses both changes.
Do not silently call another expanded driver an unchanged immediate boundary.
For the anchor, put diagnostic result storage, mode selection and expected-byte
loading before fixture setup; after commit use only the retained checks and
timer scaffolding until the first call. Audit generated source against the
retained driver. [Prior probe](../core-residual-profile-20261031/serialization_history_probe.rs),
[disclosed perturbation](../core-residual-profile-20261031/report.md).

### 2. Separate sink choice from output growth

Use an explicitly diagnostic driver with **one selected mode per fresh process**.
Every mode performs identical evaluate/commit. The first serialization uses
the selected mode; never run Display first and label a later writer call
first post-commit. Start at N512 across A/C/M:

| Mode | Operation | Question |
| --- | --- | --- |
| D | `value.to_string()` | Native path reference |
| V | `serde_json::to_vec(value)` | Is changing the normal sink/API operationally sufficient? |
| W128 | `to_writer(&mut output, value)`, Vec capacity 128 prepared outside write timer | Matched direct writer with growth |
| WL | Identical `to_writer`, Vec capacity at least frozen expected byte length L prepared outside write timer | Matched direct writer without growth |

For W128/WL, prepare the output **after commit**, in a separately timed setup
window, followed immediately by the write timer; report setup, write, and their
sum. Initial capacity is their only source-level difference. Use the known
frozen byte length, never a length obtained by serializing the live original
before its first call. Record actual starting/final capacity and length after
timing. Preparation is an intentional intervening allocation, so W128/WL do
not reproduce D's native context. Their write-only gain is not an end-to-end
gain; setup+write is the operational comparison.

Stop each timer immediately after the call returns, with the output still
owned. Comparisons, hashing, byte copies, result storage and destruction occur
afterward. Retain the output until verification, then drop it at a fixed stage.
For W128/WL repeats, create a fresh output at that capacity each round; reusing
the grown W128 Vec would erase the intended factor. Buffer reuse can be a
separate product experiment, explicitly including its ownership/lifetime cost.

Within each process retain O1, original repeats O2–O8, and P1/P2–P8 for a fresh
Value parsed outside timing from frozen identical bytes. Keep the original
alive. Follow the existing blocked order first; use alternating original/parsed
order only if order dependence remains material. Parsed means freshly
materialized, not cold: parsing touches memory and allocates. Each timed
output must equal frozen bytes, across modes/objects/arms; check parsed Value
equality after P1. Summarize repeats within each process before comparing fresh
process pairs. The expanded driver itself is diagnostic context.

If only the Display path retains a material arm difference, add **one**
tie-breaker: `write!(&mut String, "{value}")` with capacity 0 versus L, using
identical formatter call sites and the same setup/write/sum boundaries. Both
use Value Display; the formatter entry differs from native ToString and must
be labelled. It tests String growth without changing to the Vec writer.
Avoid a full factorial sweep before this decision requires one.

### 3. Test a traversal intervention only if the matched writers leave ambiguity

On the unresolved modes, compare sham versus a complete allocation-free
read-only walk of the original Value immediately before the first timed
serialization, in fresh processes. The walk must visit all containers, keys,
string contents and scalar values and expose a checksum through `black_box`;
reading lengths alone is not equivalent. Do not serialize, clone, parse,
format numbers, allocate a traversal stack on the heap, or build a byte buffer
in that intervention. Time and report the intervention separately and include
it in any end-to-end claim. Keep checks/results after serialization fixed.

Apply the touch/sham contrast to D and WL, not only D: persistence with a
non-growing sink bounds output growth's explanatory role. A disappearing gap
after the walk establishes sensitivity to that preceding traversal. It does
not prove cache misses or establish how the earlier commit produced the state.
The traversal changes instruction/branch activity and elapsed time as well as
data access, so it is an intervention with several possible physical effects.

## Allocation diagnostics and interpretation

If needed, build separate diagnostic binaries with a forwarding GlobalAlloc
wrapper counting alloc/alloc_zeroed/realloc/dealloc calls and requested bytes
in each setup/write/destruction window. Use fixed counters, no formatting,
logging, locks that allocate, or dynamically allocated sample storage inside
the allocator. Snapshot outside timing; preserve each output until after its
write-window snapshot. A requested realloc byte count is not the number of
bytes physically copied. Counter-equipped elapsed times are not the primary
timings, and allocation counts are not a language-level behavioral guarantee.
Rust's allocator contract permits allocation elision and warns about allocator
re-entrance. [Pinned allocator contract](https://github.com/rust-lang/rust/blob/48a229ceaefd4985c50990b14116b6d856af0985/library/core/src/alloc/global.rs#L90-L128).

Use the results to bound explanations:

| Observation | Supported conclusion | Still unresolved |
| --- | --- | --- |
| D regresses, V does not | Direct serializer sink is an operational candidate | Adapter, capacity, code generation and history remain mixed |
| W128 regresses, WL does not | Outcome depends on output-growth policy in the direct-writer intervention | Setup/state changes and actual allocator/CPU cause |
| WL still regresses, with no write-window allocations observed | Output growth alone cannot account for that diagnostic gap | Traversal, writes, code/environment interactions |
| Touch suppresses a gap in D and WL | Preceding read-only traversal changes the measured outcome | Exact cache/branch/frequency mechanism |
| Parsed values remove the gap | Original materialization/operation history matters in that schedule | Parse also changes allocation and machine state |
| M/A first native call and combined consumer window improve in the new campaign | The tested workload has an operational resolution using M | Universal speedup or physical causal explanation |

Identical observed allocation counts across arms do not imply identical
allocator state, returned addresses, page behavior or allocation latency.
Absence of a median regression alone is not proof of equivalence: retain all
pairs and uncertainty, and choose any practical acceptance margin before
collection. A meaningful operational acceptance requires same-campaign A/C/M
native first-call and evaluate+commit+serialize results, plus wider process
results and exact semantic gates. If considering a writer API change, validate
the complete allocate/write/consume lifetime instead of adopting a write-only
microbenchmark result. No proposed result establishes a specific CPU mechanism
without the corresponding hardware evidence; a working operational remedy
does not require pretending that mechanism has been identified.
