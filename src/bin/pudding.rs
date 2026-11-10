use pudding::research::Study;
use std::{env, fs, path::PathBuf};
fn run() -> Result<(), String> {
    let mut args = env::args().skip(1);
    match args.next().as_deref() {
        Some("--help" | "-h") | None => {
            println!("pudding visualise [--mode transport|equilibrium] [--output DIRECTORY]\nWrites index.html, bridge.svg and study.json. Numerical evidence, not a formal certificate.");
            return Ok(());
        }
        Some("visualise" | "visualize") => (),
        Some(value) => return Err(format!("unknown command {value}; use --help")),
    }
    let mut mode = String::from("transport");
    let mut output = PathBuf::from("artifacts/transport");
    let mut explicit_output = false;
    while let Some(arg) = args.next() {
        match arg.as_str() {
            "--mode" => mode = args.next().ok_or("--mode requires a value")?,
            "--output" => {
                output = args.next().ok_or("--output requires a directory")?.into();
                explicit_output = true;
            }
            _ => return Err(format!("unknown option {arg}")),
        }
    }
    if mode != "transport" && mode != "equilibrium" {
        return Err("mode must be transport or equilibrium".into());
    }
    if !explicit_output {
        output = PathBuf::from(format!("artifacts/{mode}"));
    }
    let study = Study::demo(mode == "equilibrium").map_err(|e| format!("solver failed: {e:?}"))?;
    fs::create_dir_all(&output).map_err(|e| e.to_string())?;
    for (name, contents) in [
        ("index.html", study.html()),
        ("bridge.svg", study.svg()),
        ("study.json", study.json()),
    ] {
        fs::write(output.join(name), contents).map_err(|e| e.to_string())?;
    }
    println!("{}\nmode={mode} residual={:.3e} iterations={}\nNumerical evidence; no formal run certificate.", output.join("index.html").display(), study.bridge.marginal_residual, study.bridge.iterations);
    Ok(())
}
fn main() {
    if let Err(error) = run() {
        eprintln!("pudding: {error}");
        std::process::exit(1);
    }
}
