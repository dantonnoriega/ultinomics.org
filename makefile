all:
	rmtrash docs ;\
	rmtrash static/post ;\
	rmtrash static/rmarkdown-libs ;\
	cd themes/hyde-y/scss ;\
	npm run build:css ;\
	cd ../../.. ;\
	cp /Users/dnoriega/Dropbox/user-files/zotero.bib ./content/post/zotero.bib ;\
	Rscript -e "blogdown::build_site()"

serve:
	Rscript -e "blogdown::serve_site()"

