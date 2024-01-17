use askama_escape::Escaper;
use core::{
    fmt::{self, Write},
    str,
};

pub struct Typ;

impl Escaper for Typ {
    fn write_escaped<W>(&self, mut fmt: W, string: &str) -> fmt::Result
    where
        W: Write,
    {
        let mut last = 0;
        for (index, byte) in string.bytes().enumerate() {
            macro_rules! go {
                ($expr:expr) => {{
                    fmt.write_str(&string[last..index])?;
                    fmt.write_str($expr)?;
                    last = index + 1;
                }};
            }

            match byte {
                b'$' => go!("\\$"),
                b'#' => go!("\\#"),
                b'\\' => go!("\\\\ "),
                _ => {}
            }
        }
        fmt.write_str(&string[last..])
    }
}
