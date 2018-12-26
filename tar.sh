cp index.R $1.R
tar -cvf releases/be-$1.tar $1.R lib simrc plotly.json
rm $1.R

