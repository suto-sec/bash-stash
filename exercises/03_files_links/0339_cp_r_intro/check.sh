# checker spec for 0339 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p datos; randtext 2 > "datos/$(word).txt"; }
extra_check() { must_use cp; }
