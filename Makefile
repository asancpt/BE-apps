run:
	rm -rf ./result \;
	Rscript index.R

see:
	open result/report.html

readme:
	Rscript -e "rmarkdown::render('README.Rmd', output_format='github_document', encoding='UTF-8')" \;
	start README.html

