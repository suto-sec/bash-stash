# checker spec for 0429 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { randtext 4 > informe.txt; }
extra_check() { must_use gzip; }
