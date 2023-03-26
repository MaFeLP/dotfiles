{%- if bibliography %}
{{ base }}.pdf : {{ base }}.tex {{ base }}.bib
	pdflatex {{ base }}.tex
	biber {{ base }}
	pdflatex {{ base }}.tex
	pdflatex {{ base }}.tex
{%- else %}
{{ base }}.pdf : {{ base }}.tex
	pdflatex {{ base }}.tex
	pdflatex {{ base }}.tex
{%- endif %}

{% if clean -%}
.PHONY : clean
clean :
	{{ clean_command }}
{%- endif %}

