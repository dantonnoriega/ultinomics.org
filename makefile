all:
	rmtrash docs ;\
	rmtrash static/posts;\
	rmtrash static/rmarkdown-libs ;\
	Rscript -e "blogdown::build_site()"

serve:
	Rscript -e "blogdown::serve_site()"

