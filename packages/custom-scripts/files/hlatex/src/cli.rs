use std::path::PathBuf;

use clap::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[command(author, version, about, long_about = None)]
struct Cli {
    /// Sets a custom config file
    #[arg(short, long, value_name = "FILE")]
    file: Option<PathBuf>,

    /// Turn debugging information on
    #[arg(short, long)]
    debug: bool,

    #[command(subcommand)]
    command: Option<Commands>,
}

#[derive(Debug, Subcommand)]
enum Commands {
    /// Adds an often used element to a latex file
    Add {
        /// The file to add an element to
        file: PathBuf,

        /// The element to append to the file
        #[arg(short, long)]
        block: Option<String>,

        /// The line at which to insert the element
        #[arg(short, long)]
        line: Option<usize>,
    },
    /// Compiles a latex document
    Compile {
        /// The document to compile
        file: PathBuf,

        /// If the bibliography should also be compiled
        #[arg(short, long)]
        bibliography: bool,

        /// If build files should be cleaned
        #[arg(short, long)]
        clean: bool,

        /// Don't run the
        #[arg(short, long)]
        no_multirun: bool,
    },
    /// Creates a new latex document
    New {
        #[arg(short, long)]
        /// The file to create
        file: Option<PathBuf>,

        #[arg(short, long)]
        /// The template to use
        template: Option<String>,
    },
}
