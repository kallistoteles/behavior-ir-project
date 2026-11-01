# Independent whole-history checker

The original executable B reconstructed genesis and every earlier operation for
each individual witness. Campaign001 records this cost and remains preserved as
an incomplete superseded experiment. The standalone one-witness checker is unchanged.

The case-level checker now constructs one new independent Core Store, applies the
complete declared public prefix and checks each proposed observation against the
next actual Core transition. It compares the entire observation: before/after
operational state, request/context, exact semantic record/error, canonical command
occurrences and committed record. Missing/extra steps and unavailable support fail.
No producer approval, A's views or cross-invocation cache enters acceptance.

Let O_i = F(M, Ω_i, I_i), and Ω_(i+1) = O_i.after. The checker accepts a proposed
sequence only when each proposed O_i equals that independently computed result.
By induction, the state used for each next check is the exact reference state.
Refusals/errors preserve the state; command-only commits change history even when
live contents agree. No unchecked suffix is accepted.

`Core032.history_exact` and `Core032.no_unchecked_suffix` in the checked History
module establish this composition for the logical model. Report006 contains the
actual axiom audit and fresh kernel replay. Core/Rust correspondence remains the
same explicit implementation trust boundary; no theorem about arbitrary Core
extraction or universally efficient verification is added.

The trusted factory instrumentation seam counts actual constructor invocations.
The public study path fixes that factory to Reference::new for the expected case.
Evidence supplies data only. Hostile later-step anchors, command omissions and
missing witnesses are rejected by the actual case-level acceptance path.

The new whole-history cost is one prefix reconstruction plus all checked steps,
rather than the sum of repeated prefixes. Full Core validation, capture, canonical
output and interpretation costs remain. This changes the implementation and its
source/binary identity, so a new immutable campaign is required. It changes neither
the accepted mathematical claim nor any production Core semantics.
