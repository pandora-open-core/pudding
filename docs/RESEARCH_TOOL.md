# Transport workflow and portable numerical artifacts

## Runtime

`cargo run --locked --bin pudding -- visualise --mode transport --output artifacts/transport`
creates three files. `--mode equilibrium` uses equal endpoints. `visualize` is an
alias. Open `index.html` directly; no build frontend, server or external CDN is
required. The CLI deliberately supports a reproducible fixture first. Custom
input is supported through `Study::solve`; arbitrary JSON ingestion is not yet a
CLI feature. Output files in the selected directory are overwritten on rerun.

| Artifact | Consumer and meaning |
| --- | --- |
| `index.html` | Interactive standalone explorer with source selection, edge threshold, hover inspection, endpoint comparison and JSON download |
| `bridge.svg` | Static scalable image for embedding, decks and screenshots; all edges included |
| `study.json` | `pudding.study.v1` numerical observations for independent analysis or future website components |

Six left/right nodes are the same atom support at the two endpoints, rather than
12 different physical objects. Each edge is one entry of the solved joint
coupling, including self-couplings. Node labels show requested source and observed
versus requested target mass. Filtering does not change the solver or metrics.
The before-scaling metric is max target error under `source * reference.transition`;
the after-scaling metric is the maximum of both source and target coupling errors.
Symmetry residual is relevant to equal-endpoint reversibility. No interpolation
animation is presented as a solved continuous path.

## Website handoff

Copy an experiment's whole three-file directory after review. The HTML is
self-contained; SVG and JSON are independently usable. Hosting and deployment are managed by the consumer. Suggested
public caption: **A reproducible finite-support bridge: inspect requested and
observed endpoint mass, with conditional equilibrium results formalised in Lean.**
Do not describe the floating-point run as a formal certificate. Keep the scope
text visible with any cropped visual. Self-hosting policy that prohibits inline
scripts will need an external-script adaptation; no hosted CSP is configured here.

## Data contract

`schema`, `crate_version`, `reference_invariant`, `reference_transition`,
`max_iterations`, `evidence_kind=numerical`, `formal_certificate=false`, `mode`, `source`,
`target`, `observed_target`, `coupling`, `transition`, `iterations`, `tolerance`,
`marginal_residual`, `baseline_residual`, `symmetry_residual` are version-one fields.
Rows of coupling sum to source, columns to target within numerical tolerance;
transition divides each row by source mass. An absolute marginal tolerance does
not imply the same row-stochastic tolerance when source probabilities are tiny.

The solver is dense and intended as a small-support reference. This is not a GPU
benchmark, a full data-exploration platform or evidence about private production
training. Runtime claims and exact theorem assumptions remain separate.
