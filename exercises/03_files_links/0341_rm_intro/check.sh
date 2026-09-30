# checker spec for 0341 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { randtext 1 > borrar.txt; mkdir carpeta; randtext 1 > "carpeta/$(word).txt"; }
extra_check() { must_use rm; }
