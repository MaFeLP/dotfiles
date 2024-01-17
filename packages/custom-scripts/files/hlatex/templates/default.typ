// Titlepage information
#let title = "{{- title -}}"
#let authors = ({{- authors -}})
{%- match date %}
  {%- when crate::templates::default_template::DateConfig::Today %}
#let date = datetime.today().display("[day].[month].[year]")
  {%- when crate::templates::default_template::DateConfig::Other with (val) %}
#let date = "{{- date -}}"
{%- endmatch %}

// Document setup & information
#set document(author: authors, title: title)
#set page(numbering: "1", number-align: center)
#set par(justify: true)
#set text(font: "New Computer Modern", lang: "{{- language_code -}}")
#show math.equation: set text(weight: 400)
#show heading: set text(font: "New Computer Modern Sans")
#set heading(numbering: "1.1")

// Title, date & authors
#align(center)[
  #block(text(font: "New Computer Modern Sans", weight: 700, 1.75em, title))
  #v(1em, weak: true)
  #date
]
#pad(
  top: 0.5em,
  bottom: 0.5em,
  x: 2em,
  grid(
    columns: (1fr,) * calc.min(3, authors.len()),
    gutter: 1em,
    ..authors.map(author => align(center, strong(author))),
  ),
)

#outline()

