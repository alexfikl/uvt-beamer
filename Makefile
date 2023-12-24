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
	assets/uvt-motto-en.png \
	assets/uvt-background-logo-white-en.png \
	assets/uvt-background-logo-white-ro.png

all: assets template

help: 								## Show this help
	@echo -e "Specify a command. The choices are:\n"
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[0;36m%-12s\033[m %s\n", $$1, $$2}'
	@echo ""
.PHONY: help

template: template.pdf images/template-00.png	## Compile template example
.PHONY: template

assets: $(TEX_THEME_ASSETS)			## Compile assets
.PHONY: assets

clean:								## Remove temporary compilation files
	rm -rf latex.out images/latex.out
	rm -rf *.aux *.log *.out
.PHONY: clean

purge: clean						## Remove all generated files
	rm -rf template.pdf $(TEX_THEME_ASSETS) images/template-*.png
	rm -rf images/*.pdf
.PHONY: purge

template.pdf: template.tex $(TEX_THEME_STY_FILES)
	$(TEXMK) $(TEXFLAGS) $<
	$(TEXMK) $(TEXFLAGS) $<

uvt-motto.pdf: images/uvt-motto.tex
	$(TEXMK) $(TEXFLAGS) --latex-cmd xelatex $<
	$(TEXMK) $(TEXFLAGS) --latex-cmd xelatex $<

images/template-00.png: template.pdf
	@rm -rf images/template-*.png
	convert \
		-verbose \
		-density 300 \
		$< \
		-quality 100 \
		-sharpen 0x1.0 \
		'images/template-%02d.png'

assets/uvt-background-logo-white-en.png: assets/uvt-background-logo-black-en.png
	convert $< -channel RGB -negate +channel $@

assets/uvt-background-logo-white-ro.png: assets/uvt-background-logo-black-ro.png
	convert $< -channel RGB -negate +channel $@

assets/uvt-motto-en.png: uvt-motto.pdf
	convert \
		-verbose \
		-density 300 \
		-background transparent \
		-flatten \
		-trim \
		$< \
		-quality 100 \
		-sharpen 0x1.0 \
		$(OUTDIR)/uvt-motto.png
	convert $(OUTDIR)/uvt-motto.png -crop 790x165+535+525 assets/uvt-motto-en.png
	convert $(OUTDIR)/uvt-motto.png -crop 820x230+535+735 assets/uvt-motto-ro.png
