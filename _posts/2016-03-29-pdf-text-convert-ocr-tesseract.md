---
layout: post
title: Converting Unsearchable PDF Files (aka PDF scans) to Raw Text Using Command Line Tools `convert` and `tesseract`
excerpt: "Often, one gets a PDF file that is a scan of a book or text, which cannot be searched (boo!). A good (but not perfect) solution is to use Optical Character Recognition (OCR) to convert the pdf to a txt file and search that instead."
modified: 2016-03-29
tags: [convert, tesseract, mac os x, terminal, ocr, pdf, txt]
comments: true
---

Often, one gets a PDF file that is a scan of a book or text, which cannot be searched (boo!). A good (but not perfect) solution is to use Optical Character Recognition (OCR) to convert the pdf to a txt file and search that instead.

Here is my solution.

# Requirements

1. Command line tools
	+ `convert`
	+ `tesseract`
	
	I installed both using [`homebrew`](http://brew.sh/). I'm using Mac OS X 10.11.3. This is important because it affects the location of where these are install of my system `/usr/local/`.
2. Knowledge and comfort using command line. Helps if you understand how to use the `find` command.

# Workflow

## 1. Convert `pdf` to `tiff`

Say we have pdf `Bookscan.pdf`. We can create a new directory `tiffs/` and then use the command line tool `convert` to convert the pdf to a tiff.

Below, we create a new directory called `tiffs/` in the same directory as `Bookscan.pdf` then convert the pdf to a tiff (here, its called `bookdown.tiff`).

```bash
mkdir tiffs
convert -density 600 -depth 4 -monochrome -background white -blur '0x2' -shave '0x200' Bookscan.pdf tiffs/bookdown.tiff
```
	
To learn more about the commands, visit the [imagemagick site](http://www.imagemagick.org/script/command-line-options.php). But in brief:

+ `density` adjust dpi
+ `depth` is the number of bits
+ `monochrome` black and white only
+ `blur` is useful for super sharp scans (thin letters are bad, thick good)
+ `shave` used to strip pixels from the output image (so you need to figure out the size of the final image). Useful when books have chapter names or numbers at the top (`0` is width, `200` is height)

(*Note that the option in the sample code above just happen to work for the set of documents I was converting.*)

## 2. Make Sure We Ignore Annoying Characters Like 'ligatures'

I found that, consistently, `tesseract` will add in [ligatures](https://en.wikipedia.org/wiki/Typographic_ligature), ruining the ability to search some words. But it is possible to keep `tesseract` from using them by creating a *blacklist*. I copied a list of ligatures from [this page](https://en.wikipedia.org/wiki/List_of_precomposed_Latin_characters_in_Unicode) 

One needs to add a file to `/usr/local/share/tessdata/configs/` (this assumes a `brew` installation in Mac OS X) to a file which contains the following:

```bash
tessedit_char_blacklist ꜲꜳÆæꜴꜵꜶꜷꜸꜹꜼꜽǱǲǳǄǅǆﬀﬃﬄﬁﬂĲĳǇǈǉǊǋǌŒœꝎꝏﬅᵫꝠꝡ
```

![Here is a screen shot of the file (named it `ligatures`).](https://www.dropbox.com/s/z7rhn1v66cm4jli/ligatures.png?raw=1)

![And here is what the directory `/usr/local/share/tessdata/configs/` looks like on my computer.](https://www.dropbox.com/s/24nwja0r0y6v2bo/ligatures_dir.png?raw=1)

## 3. Convert the tiff to text

This is pretty straight-forward. `cd` into the folder with the tiffs then run the command:

```bash
cd tiffs/
tesseract bookscan.tiff bookscan -l eng ligatures                                                            
```

Here, we are assuming the text is in English (`-l eng`) and we load the `ligature` configs file (which loads the blacklist variable).

For other tips, see the [Tesseract FAQ](https://github.com/tesseract-ocr/tesseract/wiki/FAQ). Sometimes, files are just too noisy or tilted to work. Most of the scans I've worked with are pretty clean, so I've not had to struggle with something too complicated.

Granted, if there are problems with the image, the fixes would all have to be done in the conversion stage!

## 4. (optional) Looping Through Tiffs

If you `cd` into the folder full of tiffs, you can loop through all the tiffs and convert them to texts.

```bash
cd tiffs/
find . -type f | while read F; do tesseract ${F} ${F%.tiff} -l eng ligatures; done;                          
```

Boom. Loops through and converts any and all tiffs in the directory (here, called `tiffs/`).

And that's it!

# An Example

If you to try a real example, try it with the following pdf: [`bookscan.pdf`](https://www.dropbox.com/s/ihn23r2olq211za/bookscan.pdf?dl=0)

Let's pretend you put `bookscan.pdf` in your downloads folder. We'll make a new folder called `tiffs/`, convert the pdf, then use `tesseract`.

```bash
cd ~/Downloads
mkdir tiffs
convert -density 600 -depth 4 -monochrome -background white -blur '0x2' -shave '200x450' bookscan.pdf tiffs/bookscan.tiff
cd tiffs
tesseract bookscan.tiff bookscan -l eng ligatures
```

I get the resulting [tiff](https://www.dropbox.com/s/4twn7egdkdj0ox0/bookscan.tiff?raw=1) and [txt](https://www.dropbox.com/s/ik27dm6dmjsq05n/bookscan.txt?raw=1) files.

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-76163349-1', 'auto');
  ga('send', 'pageview');

</script>