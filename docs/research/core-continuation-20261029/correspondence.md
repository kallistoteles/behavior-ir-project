# Correspondence for the replay materialization experiment

The baseline is behavior-ir-core commit
`1a3ae37623cf90b4608a678ef283ee313306d9bb`. This argument covers the single
replacement in `crates/behavior-core/src/record.rs::replay_profile`.

`reproduce_record` is the only production caller of `replay_profile`. It calls
`canonical::decode_strict(record)` first, then immediately calls
`replay_profile(module, &stored)`. Neither the parsed value nor the module changes
between those calls.

For a value returned by this strict decoder, serializing through `Json::to_string`
and decoding strictly again yields the same JSON value: null and Boolean values
are unchanged; supported i64/u64 integers retain their numeric values; JSON string
escaping preserves decoded Unicode; arrays preserve order; objects preserve their
unique keys and associated values. The initial strict decoder already excludes
floats, exponent notation, negative zero, out-of-range integers, duplicate keys and
invalid syntax. The replacement cannot admit those inputs because it occurs after
that unchanged ingress check. This is a source argument about the pinned decoder
and serializer, supported by finite controls, rather than a machine-checked proof
of Serde or the Rust implementation.

Within the current-version arm, the branch has already established
`stored.record_version == "0.8"`. The original `DecisionRecord::from_json` repeats
the strict decoding, selects that same arm and calls `validate_record08`. That
validator still executes in the candidate on the equal immutable value. Its
typed decoding, nested validation, command-archive checking and validation-error
order are untouched. The baseline temporary `DecisionRecord` is discarded; its
`diagnostics: Null`, parsed tree and retained command bag do not feed replay.

Module/profile consistency and behavior-version checks remain in their original
order after record validation. Exact reproduction, complete fact/record comparison,
prepared-parent identity checks, backend integrity, governance and historical
profile selection keep their existing implementations. No rule result, supplied
hash, prior producer approval or cross-call cache replaces them.

The `validation-work` counters intentionally change: the eliminated call no longer
increments `record_parse_calls` or `record_parse_bytes`. Those counters describe
`DecisionRecord::from_json`; they do not count the ingress call to `decode_strict`.
The counter control therefore establishes removal of the repeated constructor,
while independent lexical controls establish retention of ingress validation.

Resource consumption can differ, including allocations and peak memory. The
experiment does not claim equality of out-of-memory behavior, OS scheduling or
diagnostic call counts. It compares existing semantic outputs and typed error
selection for the complete supplied input under the same Core/backend assumptions.

The experiment establishes no permission to pass an arbitrary `Json` directly to
this validator from another boundary. Expanding that interface or reusing values
across calls would require a new audit of canonical validation, context and ownership.
