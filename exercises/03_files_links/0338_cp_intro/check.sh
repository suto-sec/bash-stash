# checker spec for 0338 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 2 > original.txt; }
extra_check() { must_use cp; }
