---
layout: post
title: Converting Unsearchable PDF Files to Raw Text Using `convert` and `tesseract`.
excerpt: "Often, one gets a PDF file that is a scan of a book or text, which cannot be searched (boo). A good (but not perfect) solution is to use Optical Character Recognition (OCR) to convert the pdf to a txt file and search that instead."
modified: 2016-03-129
tags: [convert, tesseract, mac os x, terminal, ocr]
comments: true
---

# REQUIRES

1. Command line tools
	+ `convert`
	+ `tesseract`
	
	I installed both using [`homebrew`](http://brew.sh/). I'm using Mac OS X 10.11.3. This is important because it affects the location of where these are install of my system `/usr/local/`.
2. Knowledge and comfort using command line. Helps if you understand how to use the `find` command.

# WORKFLOW

1. **Convert `pdf` to `tiff`. Best to put the tiffs in a different directory.**

	Example, say we have pdf `Bookscan.pdf`. We can create a new directory `tiffs/` and then use the command line tool `convert` the pdf to a tiff. It is important to use make dpi of *at least 300* (see the [Tesseract FAQ](https://github.com/tesseract-ocr/tesseract/wiki/FAQ)). 
	
	Below, we create a new directory called `tiffs/` in the same directory as `Bookscan.pdf` then convert the pdf to a tiff (here, its called `bookdown.tiff`).

	```bash
	mkdir tiffs
	convert -density 600 -depth 4 -monochrome -background white -blur 0x2 -shave '0x200' Bookscan.pdf tiffs/bookdown.tiff
	```

	To learn more about the commands, visit the [imagemagick site](http://www.imagemagick.org/script/command-line-options.php). But in brief:
		- `density` adjust dpi
		- `depth` is the number of bits
		- `monochrome` black and white only
		- `blur` is useful for super sharp letter scans
		- `shave` used to strip pixels from the output image (so you need to figure out the size of the final image). Useful when books have chapter names or numbers at the top (`0` is width, `200` is height)
2. **Make sure we ignore annoying characters like 'ligatures'**. I found that, consistently, `tesseract` will add in [ligatures](https://en.wikipedia.org/wiki/Typographic_ligature), ruining the ability to search some words. But it is possible to keep `tesseract` from using them by creating a **blacklist**. I copied a list of ligatures from [this page](https://en.wikipedia.org/wiki/List_of_precomposed_Latin_characters_in_Unicode) 

	One needs to add a file to `/usr/local/share/tessdata/configs/` (this assumes a `brew` installation in Mac OS X) to a file which contains the following:
	
	```bash
	tessedit_char_blacklist ꜲꜳÆæꜴꜵꜶꜷꜸꜹꜼꜽǱǲǳǄǅǆﬀﬃﬄﬁﬂĲĳǇǈǉǊǋǌŒœꝎꝏﬅᵫꝠꝡ
	```

	![Here is a screen shot of the file (named it `ligatures`).](https://www.dropbox.com/s/r9qivqz7dkmszhi/ligatures.png?raw=1)
	
	![And here is what the directory `/usr/local/share/tessdata/configs/` looks like on my computer.](https://www.dropbox.com/s/pw0rbisa3hku1nz/ligatures_dir.png?raw=1)

3. **Convert the tiff to text**. This is pretty straight-forward. `cd` into the folder with the tiffs then run the command:

	```
	cd tiffs/
	tesseract bookscan.tiff bookscan -l eng ligatures                                                            
	```
	
	Here, we are assuming the text is in English (`-l eng`) and we load the `ligature` configs file (which loads the blacklist variable).

4. **Optional looping through tiffs**. If you `cd` into the folder full of tiffs, you can loop through all the tiffs and convert them to texts.

	```
	cd tiffs/
	find . -type f | while read F; do tesseract ${F} ${F%.tiff} -l eng ligatures; done;                          
	```

Boom. Loops through and converts any and all tiffs in the directory (here, called `tiffs/`).

And that's it!