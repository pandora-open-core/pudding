# Contributing

This is an alpha research library. Small, reviewable changes and explicit scope
are welcome. Include a concrete ML consistency obligation and state whether a
change produces runtime observations, numerical experiments or formal evidence.

Run `cargo fmt --all -- --check`, `cargo test --all-targets`, and
`cargo clippy --all-targets -- -D warnings` for the core. Run Inferno diagnostic tests when changing its tensor adapter. New failure behavior should have tests,
especially nonfinite inputs, shape mismatch and invalid tolerances.

For Lean changes, use the pinned toolchain, build the relevant targets and run
the transitive axiom audit. Do not use `sorry` or add unreviewed axioms. Preserve
theorem hypotheses and provenance.

Contributions are provided under MPL-2.0. Do not include model weights, private
configuration, credentials or generated build caches.
