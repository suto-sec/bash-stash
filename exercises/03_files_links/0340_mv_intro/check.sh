# checker spec for 0340 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 2 > viejo.txt; }
extra_check() { must_use mv; must_not_use cp; }
