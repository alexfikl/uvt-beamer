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
| `progressbar`                     | Adds a simple progress bar to the footer |
| `sectiontoc`                      | Add full Table of Contents on section slides |
| `language=<lang>`                 | One of *english* or *romanian*        |
| `showframe`                       | [DEBUG] Shows a frame around page elements (margins, etc.) |
| `layoutgrid`                      | [DEBUG] Adds a debug grid to check alignment  |

The `language` is used to automatically select the logos with appropriate text.
This can be avoided by providing your own logos using the following commands,
but care must be taken to size them nicely.

| Macro                             | Description                           |
| :-                                | :-                                    |
| `\uvtslidelogo`                   | Transparent logo used as background on slides |
| `\venue`                          | Venue name (for the presentation) in footer |

The standard branding colors are given below. The `UVTBeamer` colors are exclusively
used in this template and taken from the official documents.

| Color                             | RGB
| :-                                | :-
| `UVTDarkBlue`                     | ![#033A89](https://placehold.co/15x15/033A89/033A89.png) `(3, 58, 137)`   |
| `UVTSkyBlue`                      | ![#2588E7](https://placehold.co/15x15/2588E7/2588E7.png) `(37, 136, 231)` |
| `UVTLightBlue`                    | ![#AED9F8](https://placehold.co/15x15/AED9F8/AED9F8.png) `(174, 217, 248)` |
| `UVTBlack`                        | ![#121212](https://placehold.co/15x15/121212/121212.png) `(18, 18, 18)` |
| `UVTAccentWhite`                  | ![#FCF5F7](https://placehold.co/15x15/FCF5F7/FCF5F7.png) `(252, 245, 247)` |
| `UVTWhite`                        | ![#FFFFFF](https://placehold.co/15x15/FFFFFF/FFFFFF.png) `(255, 255, 255)` |
| `UVTBeamerYellow`                 | ![#E3AB23](https://placehold.co/15x15/E3AB23/E3AB23.png) `(228, 172, 36)` |
| `UVTBeamerDarkBlue`               | ![#002561](https://placehold.co/15x15/002561/002561.png) `(0, 37, 97)` |
| `UVTBeamerDarkGray`               | ![#A6A6A6](https://placehold.co/15x15/A6A6A6/A6A6A6.png) `(166, 166, 166)` |

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

## Logos

The logos used by this template are automatically generated from the logo
package found on [the official website](https://dci.uvt.ro/identitate-vizuala/).
This should give you an archive that you can put in `logos.out/Logos.rar` and then
run
```bash
just logo
just background_tile
```
to generate the logos used in the template (header logos and background slide logos)
and the background used in the title and section pages. You can tweak these, if
needed to change the colors, etc.

To use a department logo in the template, you can check out the [UVT Letterhead
Template](https://github.com/alexfikl/uvt-letterhead), which has a lot more
logos in the `assets` folder.

## Acknowledgements

Some theme elements were heavily inspired (if not outright copied) from other
cool themes. Some of the block theming is taken from
[amurmaple](https://gitlab.gutenberg-asso.fr/mchupin/amurmaple). You should
check them out if you need a fancy and clean template for your presentations.

## License

Creative Commons Attribution 4.0 International
