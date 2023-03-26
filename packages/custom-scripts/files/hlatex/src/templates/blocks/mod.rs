pub(crate) mod image;
use std::fmt::Display;

pub use image::Image;

pub(crate) trait RequiredPackages {
    fn required_packages<'a>() -> Vec<Package<'a>> {
        vec![]
    }
}

#[derive(Debug, Default, Clone, PartialEq, PartialOrd)]
pub(crate) struct Package<'a> {
    pub name: &'a str,
    pub options: Vec<&'a str>,
}

impl<'a> Display for Package<'a> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut out = String::from("\\usepackage");
        if !self.options.is_empty() {
            out.push_str(&format!("[{}]", self.options.join(",")));
        }
        out.push('{');
        out.push_str(self.name);
        out.push('}');
        write!(f, "{}", out)
    }
}

fn validate_latex_size(input: &String) -> Result<(), String> {
    if input.is_empty() {
        return Ok(());
    }

    // regex generated with melody (https://github.com/yoav-lavi/melody)
    // from `/assets/latex_size.melody`
    let re = crate::regex!(
        r#"(?:((?:(\d?\.\d+)|\d+)(?:pt|mm|cm|in|ex|em|mu|sp))|((?:(\d?\.\d+)|\d+)(?:\\textwidth|\\linewidth)))"#
    );
    if re.is_match(input) {
        Ok(())
    } else {
        Err("Invalid Input".to_string())
    }
}
