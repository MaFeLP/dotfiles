use askama::Template;
use dialoguer::{console::Term, theme::Theme, Input, Select};
use std::path::PathBuf;
use std::{fs::File, io::Write};

pub(crate) mod blocks;
mod default_template;
pub(crate) mod makefile;
pub(crate) mod typst;
pub(crate) mod typst_headings;

pub(crate) trait Templateable {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized;
}

pub fn run(
    file: Option<PathBuf>,
    template: Option<String>,
    term: &Term,
    theme: &dyn Theme,
) -> dialoguer::Result<()> {
    let file = match file {
        Some(f) => f,
        None => {
            let input: String = Input::with_theme(theme)
                .with_prompt("File Name")
                .validate_with(|input: &String| -> Result<(), &str> {
                    if !input.ends_with(".tex") && !input.ends_with(".typ") {
                        return Err("Filename must end in '.tex'!");
                    }
                    if PathBuf::from(input).exists() {
                        return Err("File already exists!");
                    }
                    Ok(())
                })
                .interact_on(&term)?;
            PathBuf::from(input)
        },
    };
    let mut output_file = File::create(&file)?;
    let output = match template {
        Some(t) => match t.to_ascii_lowercase().as_str() {
            "default-tex" => default_template::DefaultTemplate::create_template(&term, theme)?
                .render()
                .expect(
                    "Rendering the template went wrong! Please create an issue on the bug tracker!",
                ),
            "default-typ" => typst::DefaultTemplate::create_template(&term, theme)?
                .render()
                .expect(
                    "Rendering the template went wrong! Please create an issue on the bug tracker!",
                ),
            "headings-typ" => typst_headings::DefaultTemplate::create_template(&term, theme)?
                .render()
                .expect(
                    "Rendering the template went wrong! Please create an issue on the bug tracker!",
                ),
            _ => "".to_string(),
        },
        None => {
            match Select::with_theme(theme)
                .with_prompt("Which Template?")
                .default(0)
                .item("Default Template (LaTeX)")
                .item("Default Template (typst)")
                .item("Headers Only (typst)")
                .item("MLA Essay")
                .item("Chemical Paper")
                .interact_on(&term)?
            {
                0 => default_template::DefaultTemplate::create_template(&term, theme)?
                    .render()
                    .expect(
                    "Rendering the template went wrong! Please create an issue on the bug tracker!",
                ),
                1 => typst::DefaultTemplate::create_template(&term, theme)?
                    .render()
                    .expect(
                        "Rendering the template went wrong! Please create an issue on the bug tracker!",
                    ),
                2 => typst_headings::DefaultTemplate::create_template(&term, theme)?
                    .render()
                    .expect(
                        "Rendering the template went wrong! Please create an issue on the bug tracker!",
                    ),
                _ => "".to_string(),
            }
        }
    };
    writeln!(output_file, "{}", output)?;
    Ok(())
}
