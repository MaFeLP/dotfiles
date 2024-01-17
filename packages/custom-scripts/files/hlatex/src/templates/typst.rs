use std::io::Error;
use super::Templateable;
use askama::Template;
use dialoguer::{console::Term, theme::Theme, Input};
use crate::templates::default_template::{DateConfig, BLANK_TO_CONTINUE};

#[derive(Template)]
#[template(path = "default.typ")]
pub struct DefaultTemplate {
    title: String,
    authors: String,
    date: DateConfig,
    language_code: String,
}

const DEFAULT_LANGUAGE_CODE: &'static str = "de";

impl Templateable for DefaultTemplate {
    fn create_template(term: &Term, theme: &dyn Theme) -> Result<Self, Error> where Self: Sized {
        let title: String = Input::with_theme(theme)
            .with_prompt("Title")
            .interact_text_on(&term)?;
        let mut input = String::new();
        let mut authors_input: Vec<String> = vec![];
        while input != BLANK_TO_CONTINUE.to_string() {
            input = Input::with_theme(theme)
                .with_prompt("Author")
                .allow_empty(true)
                .default(BLANK_TO_CONTINUE.to_string())
                .show_default(true)
                .interact_text_on(&term)?;
           authors_input.push(input.clone());
        }
        authors_input.pop(); // Remove leave blank to continue from list
        let authors = authors_input.iter().map(|elem|
            format!("\"{elem}\",")
        ).collect();
        let date: DateConfig = DateConfig::create_template(&term, theme)?;
        let language_code: String = Input::with_theme(theme)
            .with_prompt("Language Code")
            .default(DEFAULT_LANGUAGE_CODE.to_string())
            .interact_text_on(&term)?;

        Ok(Self {
            title,
            authors,
            date,
            language_code,
        })
    }
}