# UVT Beamer Theme

[![GitHub Actions Workflow Status](https://github.com/alexfikl/uvt-beamer/actions/workflows/ci.yml/badge.svg)](https://github.com/alexfikl/uvt-beamer/actions/workflows/ci.yml)
[![Open in Overleaf](https://img.shields.io/static/v1?label=LaTeX&message=Open-in-Overleaf&color=47a141&style=flat&logo=overleaf)](https://www.overleaf.com/docs?snip_uri=https://github.com/alexfikl/uvt-beamer/archive/refs/heads/main.zip)

> [!NOTE]
> This template style is fairly complete and working well, but any feature requests
> or bug reports to improve it are **very welcome**! The theme should adjust to
> various aspect ratios and page sizes.

This is a reproduction of the UVT (West University of Timișoara) Power Point
template in LaTeX. It uses the official [UVT branding](https://dci.uvt.ro/identitate-vizuala)
and is based on the example given in the
[Official Manual](https://www.dci.uvt.ro/wp-content/uploads/2019/03/MANUAL-IDENTITATE-NEW-WEB-FINAL-2016-.pdf).
As the example in the official branding manual is not very friendly to scientific
presentations, this theme will probably take some liberties with it.

Templates in the same series:
* [UVT Letterhead Template](https://github.com/alexfikl/uvt-letterhead)
* [UVT Beamer Presentation Template](https://github.com/alexfikl/uvt-beamer)
* [UVT Conference Poster Template](https://github.com/alexfikl/uvt-poster)

## What it Looks Like

![template](template.png "UVT Beamer Presentation Template")

## How to Use It

Copy the `beamerthemeuvt.sty` and the accompanying `beamercolorthemeuvt.sty`
file to your local directory together with any relevant assets from the
`assets` folder. You can use the `template.tex` file to get you started with a
few useful options and examples. The `template.tex` can then be built with
`PDFLaTeX` (or `XeLaTeX` or `LuaLaTeX` for the adventurous).

The package defines the following options used as `\usetheme[opts]{uvt}`.

| Option                            | Description                           |
| :-                                | :-                                    |
| `helveticanow`                    | Attempt to load the the *Helvetica Now Display* fonts |
| `language=<lang>`                 | One of *english* or *romanian*        |
| `showframe`                       | Shows a frame around page elements (margins, etc.) |
| `layoutgrid`                      | Adds a debug grid to check alignment  |

The `language` is used to automatically select the logos with appropriate text.
This can be avoided by providing your own logos using the following commands,
but care must be taken to size them nicely.

| Macro                             | Description                           |
| :-                                | :-                                    |
| `\uvtslidelogo`                   | Transparent logo used as background on slides |
| `\venue`                          | Venue name (for the presentation) in footer |

## Fonts

Note that the Official Manual recommends the [Helvetica Display
Now](https://www.monotype.com/fonts/helvetica-now) font. This font is generally
not available for free, but can be purchased from Monotype or a
[reseller](https://www.myfonts.com/collections/helvetica-now-font-monotype-imaging).
Ideally, you can get it from the university for official documents. If you
managed to get it, you will need to use the `XeLaTeX` or `LuaLaTeX` engines to
load it (since `PDFLaTeX` does not support OTF or TTF fonts).

If you do not have the recommended font, a good alternative is the open source
`TeX Gyre Heros` font (a quality classic Helvetica clone). This is loaded by
default by the template if the `helveticanow` option is not given or if the
font is not found.

If you are using `XeLaTeX` or `LuaLaTeX`, there are many other nice fonts to
keep in mind that would work well. For example: Carlito (a Calibri clone),
Caladea (a Cambria clone), Montserrat (inspired by Gotham), Adobe Source Sans,
and many others. A nice font will always make your slides look nicer!

## License

Creative Commons Attribution 4.0 International
