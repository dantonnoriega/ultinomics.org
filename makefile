all:
	rmtrash docs ;\
	cd themes/hyde-y/scss ;\
	npm run build:css ;\
	cd ../../.. ;\
	cp /Users/dnoriega/Dropbox/user-files/zotero.bib ./content/post/zotero.bib ;\
	Rscript -e "blogdown::build_site()" ;\
	touch docs/CNAME ;\
	echo "ultinomics.org" >> docs/CNAME
