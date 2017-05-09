all:
	rmtrash docs ;\
	Rscript -e "blogdown::build_site()" ;\
	touch docs/CNAME ;\
	echo "ultinomics.org" >> docs/CNAME

serve:
	Rscript -e "blogdown::serve_site()"

