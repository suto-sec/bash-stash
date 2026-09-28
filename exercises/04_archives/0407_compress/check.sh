# checker spec for 0407 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 300 > informe.txt; mkdir -p archivo/sub; randtext 5 > archivo/a; randtext 5 > archivo/sub/b; randtext 200 > datos.csv; compress -f datos.csv; }
