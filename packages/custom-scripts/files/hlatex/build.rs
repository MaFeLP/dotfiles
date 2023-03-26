use clap::CommandFactory;
use clap_complete::{generate_to, shells};
use clap_mangen::Man;
use std::{
    env,
    fs::{create_dir, File},
    io::{self, Write},
};

// Also imports std::path::PathBuf
include!("src/cli.rs");

fn main() -> io::Result<()> {
    let mut cmd = Cli::command();

    // OUT_DIR = target/release/build/hlatex-<hash>/out
    let mut dir = PathBuf::from(env::var_os("OUT_DIR").ok_or(io::ErrorKind::NotFound)?);
    dir.pop(); // out
    dir.pop(); // hlatex-<hash>
    dir.pop(); // build
    dir.pop(); // release
    dir.push("completions");

    if !dir.is_dir() {
        create_dir(&dir)?;
    }

    generate_to(shells::Bash, &mut cmd, env!("CARGO_PKG_NAME"), &dir)?;
    generate_to(shells::Fish, &mut cmd, env!("CARGO_PKG_NAME"), &dir)?;
    generate_to(shells::Zsh, &mut cmd, env!("CARGO_PKG_NAME"), &dir)?;

    dir.pop();
    dir.push("mandir");

    if !dir.is_dir() {
        create_dir(&dir)?;
    }

    let man = Man::new(cmd);
    let mut buffer: Vec<u8> = Default::default();
    man.render(&mut buffer)?;

    let mut file = File::create(dir.join(format!("{}.1", env!("CARGO_PKG_NAME"))))?;
    file.write(&buffer)?;

    println!("cargo:warning=Writing to: {}", dir.to_str().unwrap());

    Ok(())
}
