cp index.R $1.R
zip -FSr releases/be-$1.zip $1.R lib simrc plotly.json
rm $1.R
