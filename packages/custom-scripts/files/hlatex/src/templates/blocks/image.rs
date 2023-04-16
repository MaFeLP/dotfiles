use crate::templates::{blocks::Package, Templateable};
use askama::Template;
use dialoguer::{console::Term, theme::Theme, Confirm, Input};
use std::path::PathBuf;

use super::RequiredPackages;

#[derive(Debug, Template)]
#[template(path = "blocks/image.tex", escape = "none")]
pub struct Image {
    path: String,
    options: Option<ImageOptions>,
}

#[derive(Debug, Default)]
pub struct ImageOptions {
    scale: String,
    height: String,
    width: String,
}

impl RequiredPackages for Image {
    fn required_packages<'a>() -> Vec<super::Package<'a>> {
        vec![Package {
            name: "graphicx",
            options: vec![],
        }]
    }
}

impl Templateable for Image {
    fn create_template(term: &Term, theme: &dyn Theme) -> Result<Self, std::io::Error>
    where
        Self: Sized,
    {
        let path = Input::with_theme(theme)
            .with_prompt("Image path")
            .validate_with(|input: &String| -> Result<(), String> {
                if !PathBuf::from(input).is_file() {
                    return Err(format!("cannot stat '{input}': no such file"));
                }
                Ok(())
            })
            .interact_text_on(&term)?;

        let options = if Confirm::with_theme(theme)
            .with_prompt("Customize Image Options?")
            .interact_on(&term)?
        {
            println!(
                r#"The following are acceptable answers for `scale`, `width`, `height`:
  - leave empty for the default value
  - any valid latex length - pt, mm, cm, in, ex, em, mu, sp - more info: https://www.overleaf.com/learn/latex/Lengths_in_LaTeX#Units
  - <factor>\textwidth
  - <factor>\linewidth
  - \textwidth
  - \linewidth"#
            );

            let mut scale: String = Input::with_theme(theme)
                .with_prompt("Scale")
                .validate_with(super::validate_latex_size)
                .allow_empty(true)
                .interact_text_on(&term)?;
            if !scale.is_empty() {
                scale = format!("scale={scale},");
            }

            let mut height: String = Input::with_theme(theme)
                .with_prompt("Height")
                .validate_with(super::validate_latex_size)
                .allow_empty(true)
                .interact_text_on(&term)?;
            if !height.is_empty() {
                height = format!("height={height},");
            }

            let mut width: String = Input::with_theme(theme)
                .with_prompt("Width")
                .validate_with(super::validate_latex_size)
                .allow_empty(true)
                .interact_text_on(&term)?;
            if !width.is_empty() {
                width = format!("width={width},");
            }

            Some(ImageOptions {
                scale,
                height,
                width,
            })
        } else {
            None
        };

        Ok(Image { path, options })
    }
}