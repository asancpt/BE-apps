cp index.R $1.R
zip -FSr -ll releases/be-$1.zip $1.R lib simrc assets *.Rmd
rm $1.R
