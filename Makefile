## define output directory
out_dir := docs

## define the name of source files as below
rmd_source := report.Rmd

## preamble in .tex under directory latex
preamble := $(wildcard latex/*.tex)

## corresponding output names
pdf_out := $(patsubst %.Rmd,docs/%.pdf,$(rmd_source))
html_out := $(patsubst %.Rmd,docs/%.html,$(rmd_source))
tmp_html_out := $(patsubst %.Rmd,%.html,$(rmd_source))
tmp_files := $(patsubst %.Rmd,%_files,$(rmd_source))
tmp_pdf_out := $(patsubst %.Rmd,%.pdf,$(rmd_source))
bib_out := $(patsubst %.Rmd,%.bib,$(rmd_source))

## for slides
slides_source := index.Rmd
slides_out := $(patsubst %.Rmd,docs/%.html,$(slides_source))
tmp_slides_out := $(patsubst %.Rmd,%.html,$(slides_source))
slides_files := $(patsubst %.Rmd,%_files,$(slides_source))

## CRAN mirror
repos := https://cloud.r-project.org
dep_pkgs := c(\"revealjs\", \"bookdown\")


.PHONY: all
all: $(pdf_out) $(html_out) $(slides_out)


.PHONY: pdf
pdf: $(pdf_out)

$(pdf_out): $(rmd_source) _output.yml $(preamble)
	@make -s check
	@echo "compiling to pdf file..."
	@Rscript --vanilla -e \
	"rmarkdown::render('$<', 'bookdown::pdf_document2')"
	@mv $(tmp_pdf_out) docs/


.PHONY: html
html: $(html_out)

$(html_out): $(rmd_source) _output.yml
	@make -s check
	@echo "compiling to html file..."
	@Rscript --vanilla -e \
	"rmarkdown::render('$<', 'bookdown::html_document2')"
	@mv $(tmp_html_out) docs/


.PHONY: slides
slides: $(slides_out)

$(slides_out): $(slides_source)
	@make -s check
	@Rscript \
	-e "rmarkdown::render('$<', 'revealjs::revealjs_presentation')"
# -e "source('docker/enable_checkpoint.R');"
	@mv $(tmp_slides_out) docs
	@rm -rf docs/$(slides_files)
	@mv $(slides_files) docs/


.PHONY: check
check:
	@Rscript \
	-e "foo <- ! $(dep_pkgs) %in% installed.packages()[, 'Package'];" \
	-e "if (any(foo)) install.packages($(dep_pkgs)[foo], repos = '$(repos)')"

# .PHONY: bib
# bib: $(bib_out)

# %.bib: %.aux
#	bibexport -o $@ $<

.PHONY: clean
clean:
	@rm -rf *.aux *.bbl *.blg *.fls *.fdb_latexmk\
		*.log *.out .Rhistory *\#* .\#* *~

.PHONY: rmCache
rmCache:
	rm -rf *_files *_cache
