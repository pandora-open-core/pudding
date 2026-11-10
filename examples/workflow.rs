use pudding::{Check, Engine, TensorSnapshot, Tolerance};
fn main() {
    let posterior = TensorSnapshot::new(vec![3], vec![0.2, 0.3, 0.5]);
    let mut engine = Engine::new();
    engine.check(
        "posterior normalization",
        Check::Probability {
            tensor: &posterior,
            tolerance: Tolerance::new(1e-12, 0.0),
        },
    );
    let report = engine.finish();
    println!("Runtime consistency: {report:#?}");
    assert!(report.passed());
}
