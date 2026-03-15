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
logo_background lang page:
    qpdf --empty \
        --pages '{{ LOGOSDIR }}/Logo UVT - 2017.pdf' {{ page }} -- \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    pdfcrop {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}.pdf
    magick -density 300 \
        {{ LOGOSDIR }}/uvt-background-logo-black-{{ lang }}-crop.pdf \
        assets/uvt-background-logo-black-{{ lang }}.png
    magick \
        assets/uvt-background-logo-black-{{ lang }}.png \
        -channel RGB -negate +channel \
        assets/uvt-background-logo-white-{{ lang }}.png

[private]
logo_tile input output:
    #!/usr/bin/env bash
    set -euo pipefail

    magick '{{ input }}' -rotate 0   '{{ LOGOSDIR }}/logo-uvt-tile-000.png'
    magick '{{ input }}' -rotate 90  '{{ LOGOSDIR }}/logo-uvt-tile-090.png'
    magick '{{ input }}' -rotate 180 '{{ LOGOSDIR }}/logo-uvt-tile-180.png'
    magick '{{ input }}' -rotate 270 '{{ LOGOSDIR }}/logo-uvt-tile-270.png'

    W=$(magick identify -format '%w' '{{ input }}')
    H=$(magick identify -format '%h' '{{ input }}')
    S=$((2*H + W))
    HALF=$((H / 2))

    magick -size ${S}x${S} xc:none \
        '{{ LOGOSDIR }}/logo-uvt-tile-000.png' -geometry +$((H + 32))+$((HALF + 56)) -composite \
        '{{ LOGOSDIR }}/logo-uvt-tile-090.png' -geometry +28+$((H + 32)) -composite \
        '{{ LOGOSDIR }}/logo-uvt-tile-270.png' -geometry +$((H + W - 28))+$((H - 32)) -composite \
        '{{ LOGOSDIR }}/logo-uvt-tile-180.png' -geometry +$((H - 32))+$((H + W - HALF - 56)) -composite \
        "{{ LOGOSDIR }}/$(basename {{ without_extension(output) }}).png"

    magick -density 300 \
        "{{ LOGOSDIR }}/$(basename {{ without_extension(output) }}).png" \
        {{ output }}

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
    @just logo_tile '{{ LOGOSDIR }}/Asset 4@2x.png' 'assets/logo-uvt-tile.pdf'
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
    rm -rf {{ TEXOUTDIR }} images/{{ TEXOUTDIR }}
    rm -rf {{ LOGOSDIR }}
    rm -rf *.aux *.log *.out

[doc("Remove all generated files")]
purge: clean
    rm -rf *.pdf images/*.pdf images/template.png
    rm -rf assets/uvt-motto-*.pdf
    rm -rf assets/uvt-background-logo-*.png
