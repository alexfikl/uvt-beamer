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

[doc("Compile preview of example file (used in README)")]
preview: template
    magick \
        -verbose \
        -density 300 \
        template.pdf[0-5,16,18] \
        -quality 100 \
        -sharpen 0x1.0 \
        '{{ TEXOUTDIR }}/template-%02d.png'
    montage {{ TEXOUTDIR }}/template-*.png \
        -border 1 -tile 2x4 -geometry 1000x \
        template.png

[doc("Rebuild assets")]
assets: logo background_tile

[private]
background_tile:
    #!/usr/bin/env bash
    set -euo pipefail

    cd assets
    {{ TEXMK }} -pdflua -output-directory=../{{ TEXOUTDIR }} uvt-background-tile.tex
    cp ../{{ TEXOUTDIR }}/uvt-background-tile.pdf uvt-background-tile.pdf


[private]
logo_background lang page:
    qpdf --empty \
        --pages '{{ LOGOSDIR }}/Logo UVT - 2017.pdf' {{ page }} -- \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    pdfcrop {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    magick -density 300 \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}-crop.pdf \
        assets/uvt-background-logo-black-{{ lang }}.png

[private]
logo_tile input page output:
    #!/usr/bin/env bash
    set -euo pipefail

    # extract the logo
    qpdf '{{ input }}' --pages '{{ input }}' '{{ page }}' -- '{{ LOGOSDIR }}/logo-uvt.pdf'
    pdfcrop --bbox '0 100 200 250' '{{ LOGOSDIR }}/logo-uvt.pdf' '{{ LOGOSDIR }}/logo-uvt-crop.pdf'

    # negate the colors (why is this so hard!?!)
    inkscape --export-filename='{{ LOGOSDIR }}/logo-uvt.svg' '{{ LOGOSDIR }}/logo-uvt-crop.pdf'
    sed -i 's/fill:#231f20/fill:#FFFFFF/g' '{{ LOGOSDIR }}/logo-uvt.svg'
    inkscape --export-filename='{{ LOGOSDIR }}/logo-uvt-neg.pdf' \
        --export-background-opacity=0 \
        '{{ LOGOSDIR }}/logo-uvt.svg'

    # trim
    pdfcrop --margins 0 '{{ LOGOSDIR }}/logo-uvt-neg.pdf' '{{ output }}'

[private]
logo_extract input output:
    magick '{{ input }}' \
        -gravity center -background transparent \
        -extent 600x600 \
        '{{ output }}-white.png'

    magick '{{ output }}-white.png' \
        -colorspace sRGB -fill '#002561' -fuzz 5% -opaque white \
        '{{ output }}-blue.png'

[doc("Download logos and preprocess them")]
logo:
    @mkdir -p {{ LOGOSDIR }}
    unrar e -idq -o+ {{ LOGOSDIR }}/Logos.rar {{ LOGOSDIR }}/
    @just logo_background ro 14
    @just logo_background en 16
    @just logo_tile '{{ LOGOSDIR }}/Logo UVT - 2017.pdf' 16 'assets/logo-uvt-tile.pdf'
    @just logo_extract '{{ LOGOSDIR }}/Asset 4@2x.png' 'assets/logo-uvt'

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
    rm -rf {{ TEXOUTDIR }}
    rm -rf {{ LOGOSDIR }}
    rm -rf *.aux *.log *.out

[doc("Remove all generated files")]
purge: clean
    rm -rf *.pdf template.png
    rm -rf assets/uvt-background-logo-*.png
    rm -rf assets/uvt-background-tile.pdf
