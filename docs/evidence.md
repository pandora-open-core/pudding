# Evidence contract

Pudding currently provides runtime evidence and carries a separate Lean proof
corpus. It does not yet generate Lean statements from workflow execution.

| Evidence | What it establishes | Limits |
| --- | --- | --- |
| Runtime report | Named checks held on owned host snapshots | No universal theorem, source identity, gradient guarantee or execution attestation |
| DKMP evaluation | A bounded DAG executed with finite/domain guards | Platform f64/libm; no interval or rounding-error certificate |
| Lean kernel build and axiom audit | The inherited statements follow under their hypotheses and allowed axioms | Does not bind an Inferno binary, checkpoint, configuration or GPU implementation |

`TensorSnapshot` stores shape and flattened f64 values. A scalar has shape `[]`
and one value. Zero-sized tensors are allowed for shape/finiteness checks;
comparisons and probabilities require nonempty observations. Shape products use
checked arithmetic. All runtime obligations require valid shape/storage and
finite values. Comparison requires identical shapes, never implicit broadcast.
Tolerance is symmetric: `|a-b| <= absolute + relative*max(|a|,|b|)`; values are
scaled before subtraction to avoid floating-point overflow. This remains a
floating-point diagnostic, with rounding near the threshold. Tolerances must
be finite and nonnegative. They are chosen by the caller, not inferred as error
bounds. Probability checks sum a rank-one vector in host f64, with strictly
nonnegative entries and approximate total mass one.

Reports collect every submitted obligation; callers must inspect `passed()`.
An empty report is inconclusive and returns false. Backend read or execution
errors in the Inferno adapter return Candle errors instead of passing reports.
No report serialization, persistent identity, signing, theorem correspondence
or automatic proof discovery is implemented in the alpha.

DKMP v1 retains its `DKMP` magic plus version 1, little-endian u16 input count,
node count and root. It supports input, f64 constant, add/sub/mul/div/exp/log.
Budgets are 4096 nodes, 256 inputs and 1–64 independent lanes. Forward references,
cycles, trailing bytes, nonfinite values and invalid domains are rejected.
Every node executes, including unused nodes; exp underflow to zero is rejected.
The evaluator is inherited unchanged from dk-lean4. Its arithmetic does not
provide certified error bounds or a translation from Inferno `Expr` nodes.
