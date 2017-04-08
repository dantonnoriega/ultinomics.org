---
title: "RMarkdown (.Rmd) to MS Word (.docx) aka rmarkdown2docx"
summary: "Love Rmarkdown (.Rmd) but hate that you sometimes have to produce MS Word (.docx) files? BOOM! Solved. This post shows you how. Well, it sources the repo I made that shows you how!"
tags: ["markdown", "rmarkdown", "rmd", "docx", "word", "conversion", "reproducible"]
date: 2016-04-14
---

This post is just a copy of README.md file for the repo [https://github.com/ultinomics/rmarkdown2docx](https://github.com/ultinomics/rmarkdown2docx). But it's got everything you need to get your R Markdown file (.Rmd) to a clean, useful MS Word file (.docx).

# Description

This set of scripts help convert the output of `Rmd` files to `docx` files. It is done by creating a clean `html` file, then opening, converting, and saving the `html` to `docx` using [Applescript and Microsoft Word](https://www.dropbox.com/s/4bwwsgod27w1fjo/word-2004-applescript-reference.pdf?dl=0).

The workhorse script is a `makefile`. Just change the variables to convert any `Rmd` to `docx`. However, only clean (not standalone) `html` files will fully convert. There are some caveats (outlined below) if you want to keep a standalone `html` file.

In this repo, the `makefile` converts `example.Rmd` to `example.docx`.

## The output files

- `example.html`
- `example.docx`

## The main support file

- `html2docx.sh`

The `makefile` automatically downloads the `html2docx.sh` conversion script using `wget` if it's missing. (Requires unix command-line tool `wget` to download if missing.)

## Optional support files

- `chicago-author-date.csl`
- `bibliography.bib`

These files are listed to show that folks can cite references (useful for academics). To learn more about these RMarkdown `yaml` options, see this [RStudio post](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html).

# Requirements

1. Microsoft Word for Mac in your Applications folder. This has been built and testing using Microsoft Word for Mac, Version `15.20`.
2. `R` with packages `rmarkdown` and `knitr`.
3. An understanding of how to use GNU Make and terminal commands.

# How to Use

There are two options for going from `Rmd` to `docx`. The first `make` option is `all` and the second is `alt`. But before anything, make sure the `makefile` variables are set up accordingly. Simply change the `RMD_NAME` variable to suite your needs:

```
RMD_NAME = example.Rmd
```

In this case, the `Rmd` file of interest is `example.Rmd`.


## Option 1: `all`

Simply run

```
make all
```

Although one can knit an `html` file from a `Rmd` file---letting knitr run the `pandoc` step---there is a caveat.

> output options `self_contained` **must** be `FALSE`. Otherwise, Microsoft Word will crash during the `html` to `docx` conversion. Keep in mind that this is the default option for `rmarkdown`. But I force it to be true in the `makefile`.


## Option 2: `alt`

You cannot convert a self contained (aka standalone) `html` file to a `docx`. (At least I've found that it always crashes.) If you want the option to have a standalone `html` file, then then we use option `alt`.

Simply run

```
make alt
```

This will produce a clean (not self contained) `html`, create a `docx` file, then replace the clean `html` file with a standalone file.

It's a little hackish, but it allows you to create a `docx` AND keep a standalone `html` file.

# First Run, Word will ask for permission

When you first run the script, do not worry if Word asks for permissions. Once you give Word access to the folder and files, it should run just fine and without asking again every time after.

# Shortcomings

## Footnotes

Footnotes, not matter what, go to the bottom of the page. Just how html files work.

# Thanks

A special thanks to [Andrew Heiss](http://github.com/andrewheiss), from whom I've learned almost all I know about makefiles and converting markdown files to docx files.
