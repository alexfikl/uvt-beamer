TEXMK?=latexrun
OUTDIR=latex.out
TEXFLAGS?=--latex-cmd pdflatex -O $(OUTDIR)

TEX_THEME_STY_FILES=\
	beamerthemeuvt.sty \
	beamercolorthemeuvt.sty \
	beamerfontthemeuvt.sty \
	beamerinnerthemeuvt.sty \
	beamerouterthemeuvt.sty
TEX_THEME_ASSETS=\
	assets/uvt-motto-en.pdf \
	assets/uvt-background-logo-white-en.png \
	assets/uvt-background-logo-white-ro.png

all: assets template

help: 								## Show this help
	@echo -e "Specify a command. The choices are:\n"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-12s\033[m %s\n", $$1, $$2}'
	@echo ""
.PHONY: help

template: template.pdf images/template.png	## Compile template example
.PHONY: template

assets: $(TEX_THEME_ASSETS)			## Compile assets
.PHONY: assets

clean:								## Remove temporary compilation files
	rm -rf latex.out images/latex.out
	rm -rf *.aux *.log *.out
.PHONY: clean

purge: clean						## Remove all generated files
	rm -rf template.pdf $(TEX_THEME_ASSETS) images/template.png
	rm -rf images/*.pdf uvt-motto.pdf
.PHONY: purge

template.pdf: template.tex $(TEX_THEME_STY_FILES) $(TEX_THEME_ASSETS)
	$(TEXMK) $(TEXFLAGS) $<
	$(TEXMK) $(TEXFLAGS) $<

$(OUTDIR)/uvt-motto.pdf: images/uvt-motto.tex
	$(TEXMK) $(TEXFLAGS) --latex-cmd xelatex $<
	$(TEXMK) $(TEXFLAGS) --latex-cmd xelatex $<
	mv $(shell basename $@) $@

images/template.png: template.pdf
	@rm -rf images/template-*.png
	convert \
		-verbose \
		-density 300 \
		$<[0-5,12-13] \
		-quality 100 \
		-sharpen 0x1.0 \
		'$(OUTDIR)/template-%02d.png'
	montage $(OUTDIR)/template-*.png -border 1 -tile 2x4 -geometry 1000x $@

assets/uvt-background-logo-white-en.png: assets/uvt-background-logo-black-en.png
	convert $< -channel RGB -negate +channel $@

assets/uvt-background-logo-white-ro.png: assets/uvt-background-logo-black-ro.png
	convert $< -channel RGB -negate +channel $@

assets/uvt-motto-en.pdf: $(OUTDIR)/uvt-motto.pdf
	pdfcrop --margins '0 -50 0 -520' $(OUTDIR)/uvt-motto.pdf assets/uvt-motto-ro.pdf
	pdfcrop --margins '0 1 0 -581' $(OUTDIR)/uvt-motto.pdf assets/uvt-motto-en.pdf
