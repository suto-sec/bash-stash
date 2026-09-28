# checker spec for 1609 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=copia.sh
COMPARE="stdout stderr exit files"
setup() { randtext 2 > "a b.txt"; randtext 1 > lleno.txt; touch vacio.txt; }
ARGS=('"a b.txt" nuevo.txt' '"a b.txt" lleno.txt' '"a b.txt" vacio.txt' 'nada.txt x.txt' '' 'x')
