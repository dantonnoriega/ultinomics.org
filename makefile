all:
	rmtrash docs ;\
	rmtrash static/post ;\
	rmtrash static/rmarkdown-libs ;\
	Rscript -e "blogdown::build_site()"

serve:
	Rscript -e "blogdown::serve_site()"

