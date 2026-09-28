# checker spec for 1606 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=leer.sh
COMPARE="stdout stderr exit"
setup() { randtext 4 > ok.txt; randtext 2 > secreto.txt; chmod 000 secreto.txt; }
ARGS=('' 'ok.txt' 'nada.txt' 'secreto.txt')
