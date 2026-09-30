# checker spec for 0566 (see lib/engine.sh)
SEEDS=1
setup() { echo "hola $(word) hola $(word)" > frase.txt; }
extra_check() { must_use sed; }
