#set document(author: "{{- author -}}", title: "{{- title -}}")
//TODO add line underneath the footer
#set page(
  header: [
    #set text(8pt)
    {{ title }}
    #h(1fr)
{%- match date %}
  {%- when crate::templates::default_template::DateConfig::Today %}
    #datetime.today().display("[day].[month].[year]")
  {%- when crate::templates::default_template::DateConfig::Other with (val) %}
    {{ val }}
{%- endmatch %}
  ],
  footer: locate(loc => [
      #set text(8pt)
      {{ author }}
      #h(1fr)
{%- if language_code == "de" %}
      Seite #loc.page() von #counter(page).final(loc).at(0)
{%- else %}
      Page #loc.page() of #counter(page).final(loc).at(0)
{%- endif %}
    ]
  )
)
#set par(justify: true)
#set text(font: "New Computer Modern", lang: "{{- language_code -}}")
#show math.equation: set text(weight: 400)
#show heading: set text(font: "New Computer Modern Sans")
#set heading(numbering: "1.1")

#outline()

