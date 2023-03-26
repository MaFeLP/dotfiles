use askama_escape::Escaper;
use core::{
    fmt::{self, Write},
    str,
};

pub struct Tex;

impl Escaper for Tex {
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
                b'&' => go!("\\&"),
                b'%' => go!("\\%"),
                b'$' => go!("\\$"),
                b'#' => go!("\\#"),
                b'_' => go!("\\_"),
                b'{' => go!("\\{"),
                b'}' => go!("\\}"),
                b'~' => go!("\\textasciitilde "),
                b'^' => go!("\\textasciicircum "),
                b'\\' => go!("\\textbackslash "),
                _ => {}
            }
        }
        fmt.write_str(&string[last..])
    }
}
