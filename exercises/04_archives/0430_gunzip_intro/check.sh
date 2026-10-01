# checker spec for 0430 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { randtext 4 > datos.csv; gzip datos.csv; }
extra_check() { must_use gunzip; }
