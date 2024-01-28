use dialoguer::{console::Term, theme::Theme, MultiSelect};
use std::path::PathBuf;

pub(crate) const EXTENSIONS: [&'static str; 13] = [
    ".aux", ".bbl", ".bcf", ".blg", ".lof", ".log", ".lot", ".out", ".pdf", ".run.xml", ".tex.bbl",
    ".tex.blg", ".toc",
];

pub(crate) fn clean(base_filename: &str, term: &Term, theme: &dyn Theme) -> dialoguer::Result<()> {
    let mut paths: Vec<PathBuf> = vec![];

    for path in std::fs::read_dir("./")? {
        if path.is_err() {
            continue;
        }
        let path = path.unwrap().path();
        if !path.is_file() {
            continue;
        }
        let pathbuf = path.to_path_buf();
        let filename = pathbuf
            .file_name()
            .unwrap_or_default()
            .to_str()
            .unwrap_or_default();
        for ext in EXTENSIONS {
            if format!("{base_filename}{ext}") == filename {
                paths.push(pathbuf);
                break;
            }
        }
    }

    let selected = MultiSelect::with_theme(theme)
        .items_checked(
            &paths
                .iter()
                .map(|e| match e.clone().into_os_string().into_string() {
                    Ok(s) => {
                        if s.ends_with(".pdf") {
                            (s, false)
                        } else {
                            (s, true)
                        }
                    }
                    Err(_) => ("<no display name>".to_string(), false),
                })
                .collect::<Vec<(String, bool)>>()[..],
        )
        .with_prompt("Delete selected items?")
        .interact_on(&term)?;

    for file_index in selected {
        let file = &paths[file_index];
        std::fs::remove_file(&file.as_path())?;
    }

    Ok(())
}
