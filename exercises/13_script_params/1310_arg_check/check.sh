# checker spec for 1310 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=copia.sh
COMPARE="stdout stderr exit files"
setup() { echo hola > a.txt; }
ARGS=('' 'a.txt' 'a.txt b.txt' 'x.txt b.txt' 'a.txt b.txt c.txt')
