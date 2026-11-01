# Correspondence for borrowed and reused typed records

The baseline is research source commit
`1a3ae37623cf90b4608a678ef283ee313306d9bb` plus the retained
`prior-decode-reuse.patch`. This is a source argument about the pinned Serde and
Core implementation, supported by finite differential tests. It is not a
machine-checked implementation proof.

## Borrowed deserialization

Arm B changes the input deserializer in exactly two constructors, retaining the
same owned Record08 and Record07 Rust types. The pinned owned and borrowed Value
deserializers visit the same values, preserve map/sequence order and use the same
numeric dispatch and type diagnostics. The actual field types accept both owned
and borrowed string visits and have no custom field deserializer. They still
allocate their owned result fields. This removes a preliminary complete input
clone without introducing borrowed output, a cache or a new trusted claim.

The public strict lexical decoder, version dispatch and all validators retain
their order. Differential comparisons check both exact RecordError values and
the complete CommandIntentBag, including duplicate multiplicity and canonical
encoding, against the frozen owned validators.

## Typed common fields

Arm C retains every typed v0.8 parse, profile/null check and complete child-evidence
check before selecting a common-validation path. For an object root with object
trace entries, Record08 and Record07 share all common field types and defaults.
The typed trace structures share their first ten fields with identical types.
The three additional current child fields have already been checked and were
removed by the original object projection.

Moving those common fields produces the same Record07 that the original projected
parse would construct. The version/profile strings are rewritten to the same
constants, and a missing legacy command archive receives the same empty archive.
The semantic validator body then executes in its original order. No semantic
obligation is justified solely by the fact that deserialization succeeded.

The object-root premise comes from unchanged public version dispatch. The trace
guard is explicit. The [field inventory](source-audit.md) records all shared
types, defaults and proof premises. The explicit constructors require complete
destination Record07/SemanticTrace fields at compilation. Additions confined to
Record08/CurrentTrace still require a fresh projection audit; compilation alone
does not enforce it.

## Sequence forms require the original path

Serde supports positional struct representations. CurrentTrace accepts thirteen
fields, while SemanticTrace accepts ten. An eleven-element non-child trace with
a final null is one concrete counterexample to unconditional typed conversion:
the original v0.8 parse accepts its shape, but the old projected parse rejects
it with `invalid length 11, expected fewer elements in array`.

After all existing v0.8 checks, C therefore retains the exact original raw
projection and parser whenever any trace entry is not an object. This preserves
both accepted short sequence forms and rejected longer ones. It also preserves
which v0.8 semantic failure wins over a subsequent projected shape failure.
Shared nested struct sequence forms retain their shared original Rust types.
No replacement Serde error text or new blanket sequence refusal is synthesized.

## Preserved boundary and limitations

The supplied raw record remains unchanged and is retained by the public
DecisionRecord constructor. Replay and Store still reproduce and compare the
same complete observations and enforce their existing governance and historical
context checks. No cross-call state, result cache or public constructor is added.

The source correspondence and frozen-validator corpus establish the stated
evidence for this implementation change, without proving all possible Core
executions. Allocation/drop timing and exhaustion behavior may differ; those
resource effects are measured separately from existing semantic results and
typed errors. Performance of the sequence fallback is outside the primary
object-record timing fixture.
