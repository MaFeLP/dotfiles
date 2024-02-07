use super::Templateable;
use crate::templates::default_template::DateConfig;
use askama::Template;
use dialoguer::{console::Term, theme::Theme, Input};

#[derive(Template)]
#[template(path = "headers.typ")]
pub struct DefaultTemplate {
    title: String,
    author: String,
    date: DateConfig,
    language_code: String,
}

const DEFAULT_LANGUAGE_CODE: &'static str = "de";

impl Templateable for DefaultTemplate {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized,
    {
        let title: String = Input::with_theme(theme)
            .with_prompt("Title")
            .interact_text_on(&term)?;
        let author = Input::with_theme(theme)
            .with_prompt("Author")
            .interact_text_on(&term)?;
        let date: DateConfig = DateConfig::create_template(&term, theme)?;
        let language_code: String = Input::with_theme(theme)
            .with_prompt("Language Code")
            .default(DEFAULT_LANGUAGE_CODE.to_string())
            .interact_text_on(&term)?;

        Ok(Self {
            title,
            author,
            date,
            language_code,
        })
    }
}
