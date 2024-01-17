use crate::{clean::clean, compile::compile};
use dialoguer::{
    console::Term,
    theme::ColorfulTheme,
    Completion, Select,
};

mod add;
mod clean;
mod cli;
mod compile;
mod templates;
mod tex_escape;
mod typ_escape;

include!("cli.rs");

struct TexFilesCompletion {
    files: Vec<PathBuf>,
}

impl TexFilesCompletion {
    fn new() -> Result<Self, std::io::Error> {
        let mut paths: Vec<PathBuf> = vec![];
        for path in std::fs::read_dir("./")? {
            if let Ok(p) = path {
                if p.path().is_file() {
                    paths.push(p.path().to_path_buf());
                }
            }
        }
        Ok(Self { files: paths })
    }

}

impl Completion for TexFilesCompletion {
    fn get(&self, input: &str) -> Option<String> {
        let matches = self
            .files
            .iter()
            .filter(|option| option.starts_with(input))
            .filter(|option| option.ends_with(".tex") || option.ends_with(".typ"))
            .collect::<Vec<_>>();

        if matches.len() == 1 {
            if let Some(s) = matches[0].to_str() {
                return Some(s.to_string());
            }
        }
        None
    }
}

fn main() -> Result<(), std::io::Error> {
    let cli = Cli::parse();
    let term = Term::buffered_stderr();
    let theme = ColorfulTheme::default();

    if let Some(command) = cli.command {
        #[allow(unused_variables)]
        match command {
            Commands::Add { file, block, line } => {
                add::run(Some(file), block, line, &term, &theme)?
            }
            Commands::Compile {
                file,
                bibliography,
                clean,
                no_multirun,
            } => compile(file, bibliography, clean, no_multirun, &term, &theme)?,
            Commands::New { file, template } => templates::run(file, template, &term, &theme)?,
        }
        return Ok(());
    }

    match Select::with_theme(&theme)
        .with_prompt("What do you want to do?")
        .default(0)
        .item("Create a new file from template")
        .item("Compile existing file")
        .item("Add block to existing file")
        .item("Create a GNU Makefile for an existing file")
        .item("Exit")
        .interact_on(&term)?
    {
        0 => templates::run(None, None, &term, &theme)?,
        1 => compile::run(&term, &theme)?,
        2 => add::run(None, None, None, &term, &theme)?,
        3 => templates::makefile::run(None, None, &term, &theme)?,
        _ => panic!("Unknown option chosen. This is a bug, please report it!"),
    }
    Ok(())
}

/// Took this from https://docs.rs/once_cell/latest/once_cell/index.html#lazily-compiled-regex
/// with this macro we can avoid re-initializing regexes, which are expensive to do
#[macro_export]
macro_rules! regex {
    ($re:literal $(,)?) => {{
        static RE: once_cell::sync::OnceCell<regex::Regex> = once_cell::sync::OnceCell::new();
        RE.get_or_init(|| regex::Regex::new($re).unwrap())
    }};
}
