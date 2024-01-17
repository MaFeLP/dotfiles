use std::fmt::{Display, Formatter};
use super::Templateable;
use askama::Template;
use dialoguer::{console::Term, theme::Theme, Confirm, Input, MultiSelect, Select};

#[derive(Template)]
#[template(path = "default.tex")]
pub struct DefaultTemplate {
    title: String,
    author: String,
    date: DateConfig,
    subjects: Vec<String>,
    keywords: Vec<String>,
    header: HeaderConfig,
    footer: HeaderConfig,
    macros: Option<Macros>,
}

pub(crate) const BLANK_TO_CONTINUE: &'static str = "leave blank to continue";

impl Templateable for DefaultTemplate {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized,
    {
        let mut input = String::new();

        let title: String = Input::with_theme(theme)
            .with_prompt("Title")
            .interact_text_on(&term)?;
        let author: String = Input::with_theme(theme)
            .with_prompt("Author")
            .interact_text_on(&term)?;
        let date: DateConfig = DateConfig::create_template(&term, theme)?;
        let mut subjects: Vec<String> = vec![];
        while input != BLANK_TO_CONTINUE.to_string() {
            input = Input::with_theme(theme)
                .with_prompt("Subject")
                .allow_empty(true)
                .default(BLANK_TO_CONTINUE.to_string())
                .show_default(true)
                .interact_text_on(&term)?;
            subjects.push(input.clone());
        }
        subjects.pop(); // Remove leave blank to continue from list
        let mut keywords: Vec<String> = vec![];
        input = String::new();
        while input != BLANK_TO_CONTINUE.to_string() {
            input = Input::with_theme(theme)
                .with_prompt("Keyword")
                .allow_empty(true)
                .default(BLANK_TO_CONTINUE.to_string())
                .show_default(true)
                .interact_text_on(&term)?;
            keywords.push(input.clone());
        }
        keywords.pop(); // Remove leave blank to continue from list
        let header = if Confirm::with_theme(theme)
            .with_prompt("Configure header?")
            .interact_on(&term)?
        {
            HeaderConfig::create_template(&term, theme)?
        } else {
            HeaderConfig::default()
        };
        let footer = if Confirm::with_theme(theme)
            .with_prompt("Configure footer?")
            .interact_on(&term)?
        {
            HeaderConfig::create_template(&term, theme)?
        } else {
            HeaderConfig::default()
        };
        let macros = if Confirm::with_theme(theme)
            .with_prompt("Add macros?")
            .interact_on(&term)?
        {
            Some(Macros::create_template(&term, theme)?)
        } else {
            None
        };
        Ok(Self {
            title,
            author,
            date,
            subjects,
            keywords,
            header,
            footer,
            macros,
        })
    }
}

impl Display for DateConfig {
    fn fmt(&self, _f: &mut Formatter<'_>) -> std::fmt::Result {
        todo!()
    }
}

pub enum DateConfig {
    Today,
    Other(String),
}

impl Templateable for DateConfig {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized,
    {
        Ok(
            match Select::with_theme(theme)
                .with_prompt("Select Date Type")
                .default(0)
                .item("\\today - inserts current date on build time")
                .item("custom - sets a strings as the current date (customized in next step)")
                .interact_on(term)?
            {
                1 => DateConfig::Other(
                    Input::with_theme(theme)
                        .with_prompt("Custom Date")
                        .interact_text_on(&term)?,
                ),
                _ => DateConfig::Today,
            },
        )
    }
}

#[derive(Default)]
pub struct HeaderConfig {
    left: Option<String>,
    center: Option<String>,
    right: Option<String>,
}

impl Templateable for HeaderConfig {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized,
    {
        let mut input: String = Input::with_theme(theme)
            .allow_empty(true)
            .with_prompt("Left side")
            .interact_text_on(&term)?;
        let left: Option<String> = if input.is_empty() {
            None
        } else {
            Some(input.clone())
        };
        input = Input::with_theme(theme)
            .allow_empty(true)
            .with_prompt("Center")
            .interact_text_on(&term)?;
        let center: Option<String> = if input.is_empty() {
            None
        } else {
            Some(input.clone())
        };
        input = Input::with_theme(theme)
            .allow_empty(true)
            .with_prompt("Right side")
            .interact_text_on(&term)?;
        let right: Option<String> = if input.is_empty() {
            None
        } else {
            Some(input.clone())
        };
        Ok(Self {
            left,
            center,
            right,
        })
    }
}

#[derive(Default)]
pub struct Macros {
    mkline: bool,
}

impl Templateable for Macros {
    fn create_template(term: &Term, theme: &dyn Theme) -> dialoguer::Result<Self>
    where
        Self: Sized,
    {
        let chosen: Vec<usize> = MultiSelect::with_theme(theme)
            .item_checked("mkline - Create a horizontal line over half the page", true)
            .with_prompt("Select macros")
            .interact_on(&term)?;
        let mut out = Self::default();
        for item in chosen {
            match item {
                0 => out.mkline = true,
                _ => {}
            }
        }
        Ok(out)
    }
}
