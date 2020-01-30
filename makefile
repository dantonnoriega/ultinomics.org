all:
	rmtrash docs ;\
	rmtrash static/post ;\
	rmtrash static/rmarkdown-libs ;\
	cd themes/hyde-y/scss ;\
	npm run build:css ;\
	cd ../../.. ;\
	Rscript -e "blogdown::build_site()"

serve:
	Rscript -e "blogdown::serve_site()"

