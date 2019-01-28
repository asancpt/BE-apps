run:
	rm -rf ./result \;
	Rscript index.R

see:
	open result/report.html

readme:
	Rscript -e "rmarkdown::render('README.Rmd', output_format='github_document', encoding='UTF-8')" \;
	start README.html

update:
	Rscript -e ".libPaths() ; update.packages(dir('lib'))"



pdf:
	Rscript --quiet _render.R "bookdown::pdf_book"

gitbook:
	Rscript --quiet _render.R "bookdown::gitbook"

all:
	Rscript --quiet _render.R

