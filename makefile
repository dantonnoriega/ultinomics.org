all:
	rmtrash docs ;\
	Rscript -e "blogdown::build_site()"
