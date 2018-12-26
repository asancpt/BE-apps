cp index.R $1.R
zip -FSr -ll releases/be-$1.zip $1.R lib simrc *.json *.Rmd logo-BE.jpg
rm $1.R
