TEXMK := "latexmk"
TEXOUTDIR := "latex.out"
TEXFLAGS := "-pdflua -output-directory=" + TEXOUTDIR
LOGOSDIR := "logos.out"

_default:
    @just --list

[private]
pdf basename:
    {{ TEXMK }} {{ TEXFLAGS }} {{ basename }}.tex
    @cp {{ TEXOUTDIR }}/{{ basename }}.pdf .

[doc("Compile template example (requires assets)")]
template:
    @just pdf template

[doc("Compile image of example file (used in README)")]
image: template
    @rm -rf images/template-*.png
    magick \
        -verbose \
        -density 300 \
        template.pdf[0-5,12-13] \
        -quality 100 \
        -sharpen 0x1.0 \
        '{{ TEXOUTDIR }}/template-%02d.png'
    montage {{ TEXOUTDIR }}/template-*.png \
        -border 1 -tile 2x4 -geometry 1000x \
        images/template.png

[private]
motto:
    {{ TEXMK }} {{ TEXFLAGS }} images/uvt-motto.tex
    pdfcrop --margins '0 -50 0 -520' {{ TEXOUTDIR }}/uvt-motto.pdf assets/uvt-motto-ro.pdf
    pdfcrop --margins '0 1 0 -581' {{ TEXOUTDIR }}/uvt-motto.pdf assets/uvt-motto-en.pdf

[doc("Rebuild assets")]
assets: logo motto

[private]
logo_extract lang page:
    qpdf --empty \
        --pages '{{ LOGOSDIR }}/Logo UVT - 2017/Logo UVT - 2017.pdf' {{ page }} -- \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    pdfcrop {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    magick -density 300 \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}-crop.pdf \
        assets/uvt-background-logo-black-{{ lang }}.png
    magick \
        assets/uvt-background-logo-black-{{ lang }}.png \
        -channel RGB -negate +channel \
        assets/uvt-background-logo-white-{{ lang }}.png

[doc("Download logos and preprocess them")]
logo:
    @rm -rf {{ LOGOSDIR }}
    @mkdir -p {{ LOGOSDIR }}
    @curl -o {{ LOGOSDIR }}/Logos.zip 'https://www.uvt.ro/?jet_download=534'
    7z x -o{{ LOGOSDIR }} {{ LOGOSDIR }}/Logos.zip
    @just logo_extract ro 14
    @just logo_extract en 16

[doc("Update license text")]
license:
    python -m reuse download CC-BY-4.0
    cp LICENSES/CC-BY-4.0.txt LICENSE
    @rm -rf LICENSES

[doc("Create a zip file with all the files")]
zip:
    zip -9 uvt-beamer.zip \
        LICENSE assets/* template.tex \
        beamer*themeuvt.sty

[doc("Remove all compilation files")]
clean:
    rm -rf {{ TEXOUTDIR }} images/{{ TEXOUTDIR }}
    rm -rf {{ LOGOSDIR }}
    rm -rf *.aux *.log *.out

[doc("Remove all generated files")]
purge: clean
    rm -rf *.pdf images/*.pdf images/template.png
    rm -rf assets/uvt-motto-*.pdf
    rm -rf assets/uvt-background-logo-*.png
