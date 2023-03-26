use askama::Template;
use dialoguer::{console::Term, theme::Theme, Confirm, Input};
use std::path::PathBuf;

use super::Templateable;
use crate::{clean::EXTENSIONS, TexFilesCompletion};

#[derive(Debug, Template)]
#[template(path = "Makefile")]
pub(crate) struct Makefile {
    base: String,
    bibliography: bool,
    clean: bool,
    clean_command: String,
}

impl Templateable for Makefile {
    fn create_template(term: &Term, theme: &dyn Theme) -> Result<Self, std::io::Error>
    where
        Self: Sized,
    {
        let completions = TexFilesCompletion::new()?;
        let filename = Input::with_theme(theme)
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
            .interact_text_on(&term)?;
        let base = String::from(&filename[..&filename.len() - 4]);
        let bibliography = Confirm::with_theme(theme)
            .with_prompt("Compile the bibliography as well?")
            .interact_on(&term)?;
        let clean = Confirm::with_theme(theme)
            .with_prompt("Add clean target?")
            .interact_on(&term)?;
        let mut clean_command = "	rm -vf".to_string();
        for ext in EXTENSIONS {
            clean_command.push_str(&format!(" {base}.{ext}"));
        }
        Ok(Self {
            base,
            bibliography,
            clean,
            clean_command,
        })
    }
}

pub(crate) fn run(
    file: Option<PathBuf>,
    template: Option<String>,
    term: &Term,
    theme: &dyn Theme,
) -> Result<(), std::io::Error> {
    let file = match file {
        Some(f) => f,
        None => {
            let input: String = Input::with_theme(theme)
                .with_prompt("File Name")
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
                .interact_on(&term)?;
            PathBuf::from(input)
        }
    };
    if file.exists() {
    } else {
        let template = Makefile::create_template(&term, theme)?.render().expect("");
    }
    Ok(())
}
