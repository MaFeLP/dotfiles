use crate::TexFilesCompletion;
use dialoguer::{console::Term, theme::Theme, Confirm, Input};
use std::path::PathBuf;
use std::{
    io::{self, Error, ErrorKind, Write},
    process::Command,
};

fn compile_document(filename: &String) -> std::io::Result<()> {
    let output = Command::new("pdflatex").arg(filename).output()?;
    if output.status.success() {
        return Ok(());
    }
    io::stdout().write_all(&output.stdout)?;
    io::stderr().write_all(&output.stderr)?;
    Err(Error::new(
        ErrorKind::Other,
        "pdflatex finished with an error!",
    ))
}

fn compile_bibliography(filename: &String) -> std::io::Result<()> {
    let filename = &filename[..&filename.len() - 4];
    let output = Command::new("biber").arg(filename).output()?;
    if output.status.success() {
        return Ok(());
    }
    io::stdout().write_all(&output.stdout)?;
    io::stderr().write_all(&output.stderr)?;
    Err(Error::new(
        ErrorKind::Other,
        "pdflatex finished with an error!",
    ))
}

pub(crate) fn compile(
    file: PathBuf,
    bibliography: bool,
    clean: bool,
    no_multirun: bool,
    term: &Term,
    theme: &dyn Theme,
) -> dialoguer::Result<()> {
    let filename = file
        .into_os_string()
        .into_string()
        .map_err(|_| Error::new(ErrorKind::NotFound, "The File could not be found!"))?;

    compile_document(&filename)?;
    if bibliography {
        compile_bibliography(&filename)?;
    }
    if no_multirun {
        if clean {
            crate::clean(&filename[..&filename.len() - 4], &term, theme)?;
        }
        return Ok(());
    }
    compile_document(&filename)?;
    compile_document(&filename)?;

    if clean {
        crate::clean(&filename[..&filename.len() - 4], &term, theme)?;
    }

    Ok(())
}

pub(crate) fn run(term: &Term, theme: &dyn Theme) -> dialoguer::Result<()> {
    let completions = TexFilesCompletion::new()?;
    let file = PathBuf::from(
        Input::with_theme(theme)
            .completion_with(&completions)
            .with_prompt("Filename to compile (tab to autocomplete)")
            .validate_with(|input: &String| -> Result<(), &str> {
                if !input.ends_with(".tex") {
                    return Err("File must have extension '.tex'");
                }
                let path = PathBuf::from(input);
                if !path.is_file() || !path.exists() {
                    return Err("No such file");
                }
                Ok(())
            })
            .interact_text_on(&term)?,
    );
    let bibliography = Confirm::with_theme(theme)
        .with_prompt("Compile bibliography?")
        .interact_on(&term)?;
    let clean = Confirm::with_theme(theme)
        .with_prompt("Clean after build?")
        .interact_on(&term)?;
    let no_multirun = Confirm::with_theme(theme)
        .with_prompt("Disable multiple builds (disable generation of correct references)")
        .interact_on(&term)?;
    compile(file, bibliography, clean, no_multirun, &term, theme)
}
