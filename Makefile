TEXMK?=latexrun
TEXFLAGS?=--latex-cmd xelatex -O latex.out

TEX_THEME_STY_FILES=\
	beamerthemeuvt.sty \
	beamercolorthemeuvt.sty \
	beamerfontthemeuvt.sty \
	beamerinnerthemeuvt.sty \
	beamerouterthemeuvt.sty
TEX_THEME_ASSETS=\
	assets/template-titlepage.png \
	assets/template-slide.png \
	assets/uvt-background-logo-white.png

all: template assets

help: 								## Show this help
	@echo -e "Specify a command. The choices are:\n"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-12s\033[m %s\n", $$1, $$2}'
	@echo ""
.PHONY: help

template: template.pdf				## Compile template example
.PHONY: template

assets: $(TEX_THEME_ASSETS)			## Compile assets for example
.PHONY: template

clean:								## Remove temporary compilation files
	rm -rf latex.out \
	rm -rf *.aux *.log *.out
.PHONY: clean

purge: clean						## Remove all generated files
	rm -rf template.pdf $(TEX_THEME_ASSETS)
.PHONY: purge

template.pdf: template.tex $(TEX_THEME_STY_FILES)
	$(TEXMK) $(TEXFLAGS) $<
	$(TEXMK) $(TEXFLAGS) $<

assets/template-titlepage.png: template.pdf
	convert \
		-verbose \
		-density 300 \
		-trim \
		$<[0] \
		-quality 100 \
		-flatten \
		-sharpen 0x1.0 \
		$@

assets/template-slide.png: template.pdf
	convert \
		-verbose \
		-density 300 \
		-trim \
		$<[1] \
		-quality 100 \
		-flatten \
		-sharpen 0x1.0 \
		$@

assets/uvt-background-logo-white.png: assets/uvt-background-logo-black.png
	convert $< -channel RGB -negate +channel $@
