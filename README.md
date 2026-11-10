# Pudding

Pudding is an **alpha, open-core Rust SDK** for runtime mathematical consistency
checks, finite-support Schrödinger transport, and portable numerical diagnostics.
The public core is open source under [MPL-2.0](LICENSE) and has no external Rust
dependencies. APIs and artifact formats may change during alpha.

Created and contributed by **Liam Dziga Douglas Giles**, founder and CEO of
**Pandora-AI Proprietary Ltd.**

## Install

Use a local source checkout:

```toml
[dependencies]
pudding = { path = "../pudding-open-core" }
```

The package is not published to crates.io. Rust 1.95.0 is pinned in
`rust-toolchain.toml`.

## Check a computation

```rust
use pudding::{Check, Engine, TensorSnapshot};

let values = TensorSnapshot::new(vec![2], vec![0.25, 0.75]);
let mut engine = Engine::new();
engine.check("finite values", Check::Finite(&values));
assert!(engine.finish().passed());
```

`Engine` collects named checks on owned snapshots. Checks cover shape, finiteness,
probabilities and agreement within explicit tolerances. Inspect `Report::passed()`
to determine the outcome; an empty report does not pass. See the
[evidence contract](docs/evidence.md) for numerical and formal limits.

## Visualise transport

```sh
cargo run --locked --bin pudding -- visualise --output artifacts/transport
cargo run --locked --bin pudding -- visualise --mode equilibrium --output artifacts/equilibrium
```

Open the generated `index.html`. Each output includes an interactive graph, SVG
and JSON measurements, with no web service required. Supply your own strictly
positive masses through `equilibrium::AtomReference` and `research::Study`.
See the [transport workflow](docs/RESEARCH_TOOL.md) for input requirements,
convergence behavior and artifact formats.

## Use with Inferno

Inferno imports this SDK directly and exposes it as `inferno::pudding`.
`inferno::diagnostics::{snapshot, check_operator, check_solution}` provides
Candle tensor and linear-operator checks. The adapter lives in Inferno, so
Pudding remains independent of tensor backends. See [Inferno](../inferno-open-source/README.md).

## Containers

The numerical CLI and formal audit have separate images:

```sh
podman build -f Containerfile -t pudding .
podman run --rm -v "$PWD/artifacts:/output:Z" pudding visualise --output /output/transport
podman build -f Containerfile.proofs -t pudding-proofs .
podman run --rm pudding-proofs
```

The runtime image uses an unprivileged user. Ensure the mounted output directory
is writable by UID 65532, or use an appropriate Podman user namespace mapping.
The proof image installs pinned Lean/mathlib dependencies and rechecks the
bundled corpus at build time and on execution.

## Formal scope and development

The [`Pudding` Lean library](proofs/README.md) in `proofs/lean` contains conditional mathematical statements
and transitive axiom audits. It does not certify a running binary, floating-point
solver, checkpoint or GPU execution. The finite-support equilibrium statements
assume the declared feasibility and positivity conditions; they do not establish
general continuous bridge existence or Rust solver correctness. See the
[mathematical contract](proofs/spec/schrodinger-equilibrium.md).

```sh
cargo fmt --all -- --check
cargo test --locked --all-targets
cargo clippy --locked --all-targets -- -D warnings
cargo doc --locked --no-deps
# Also requires the pinned Lean/mathlib dependencies:
sh scripts/release-check.sh
```

The open-core boundary is this public source tree. Private application training,
production orchestration and model weights are distributed separately, if at all.
See [provenance](PROVENANCE.md), [contributing](CONTRIBUTING.md) and
[security](SECURITY.md).
