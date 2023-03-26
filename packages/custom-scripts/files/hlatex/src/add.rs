use crate::templates::{
    blocks::{self, RequiredPackages},
    Templateable,
};
use askama::Template;
use dialoguer::{
    console::{Style, Term},
    theme::Theme,
    Input, Select,
};
use std::{
    fs::{write, File},
    io::{self, Read},
    path::PathBuf,
};

pub(crate) fn add(
    file: PathBuf,
    block: &str,
    line: usize,
    term: &Term,
    theme: &dyn Theme,
) -> Result<(), std::io::Error> {
    if !file.is_file() {
        return Err(io::Error::new(
            io::ErrorKind::NotFound,
            "File to write to not found!",
        ));
    }
    let (render, packages) = match block {
        "Image" => (
            blocks::Image::create_template(&term, theme)?
                .render()
                .expect("Render of template `image.tex` failed!"),
            blocks::Image::required_packages(),
        ),
        _ => panic!("Unknown block selected!"),
    };

    // READ lines from file as a vector
    let mut input_file = File::open(&file)?;
    let mut buf = String::new();
    input_file.read_to_string(&mut buf)?;
    let mut lines: Vec<String> = buf.split('\n').map(String::from).collect();

    // INSERT block into LINE NUMBER (or if file is too small, the end)
    let mut line = line;
    for l in render.split('\n') {
        if line >= lines.len() {
            lines.push(l.to_string());
        } else {
            lines.insert(line, l.to_string());
        }
        line += 1;
    }

    // CHECK if all required packages are in the file
    let package_regex = regex::Regex::new(r#"\\usepackage(\[.*\])?\{(?:[a-zA-Z0-9]+)\}"#).unwrap();
    let required_packages: Vec<String> = {
        let package_name_regex = regex::Regex::new(r#"\{(?:[a-zA-Z0-9]+)\}"#).unwrap();
        let used_packages: Vec<String> = package_regex
            .find_iter(&buf)
            .into_iter()
            .map(|mat| {
                let n = package_name_regex
                    .captures(mat.as_str())
                    .unwrap()
                    .get(0)
                    .unwrap()
                    .as_str();
                String::from(&n[1..n.len() - 1])
            })
            .collect();

        packages
            .iter()
            .filter_map(|pkg| {
                let mut used = false;
                for used_package in &used_packages {
                    if used_package == pkg.name {
                        used = true;
                        break;
                    }
                }
                if used {
                    None
                } else {
                    Some(format!("{}", &pkg))
                }
            })
            .collect()
    };

    if !required_packages.is_empty() {
        // REGISTER number of last "normal" \usepackage
        let mut last_line = {
            let mut current_line = 0;
            let mut usepackages_found = false;
            for (i, line) in lines.iter().enumerate() {
                if package_regex.is_match(&line) {
                    current_line = i;
                    usepackages_found = true;
                    continue;
                }
                // At the first empty line after the \usepackage commands, break and save last line
                if usepackages_found && line.is_empty() {
                    break;
                }
            }
            current_line
        };

        eprintln!(
            "{} One or more required packages were not imported!",
            Style::new().red().apply_to("!")
        );

        // INSERT required packages after last "normal" \usepackage
        for package in required_packages {
            last_line += 1;
            eprintln!(
                " {} Adding '{}' after line {}",
                Style::new().cyan().apply_to("->"),
                Style::new().color256(8).apply_to(&package),
                Style::new().color256(8).apply_to(last_line)
            );
            lines.insert(last_line, package);
        }
    }

    // UNIFY the lines into one string and OVERRIDE the file's contents
    write(file, lines.join("\n"))?;

    Ok(())
}

pub(crate) fn run(
    file: Option<PathBuf>,
    block: Option<String>,
    line: Option<usize>,
    term: &Term,
    theme: &dyn Theme,
) -> Result<(), io::Error> {
    let file = match file {
        Some(f) => f,
        None => {
            let input: String = Input::with_theme(theme)
                .with_prompt("File Name")
                .validate_with(|input: &String| -> Result<(), &str> {
                    if !PathBuf::from(input).exists() {
                        return Err("File doesn't exist!");
                    }
                    Ok(())
                })
                .interact_on(&term)?;
            PathBuf::from(input)
        }
    };

    let items = vec!["Image"];

    let block = match block {
        Some(b) => b,
        None => {
            let selected: usize = Select::with_theme(theme)
                .with_prompt("What block?")
                .items(&items)
                .default(0)
                .interact_on(&term)?;
            let item = items.get(selected).ok_or(io::Error::new(
                io::ErrorKind::InvalidInput,
                format!("Input must be between 0 and {}", items.len()),
            ))?;
            item.to_string()
        }
    };

    let line: usize = match line {
        Some(l) => l,
        None => Input::with_theme(theme)
            .with_prompt("Insert after line")
            .interact_on(&term)?,
    };

    add(file, &block, line, term, theme)
}
