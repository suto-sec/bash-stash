# checker spec for 1012 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in $(seq 15); do pick luke sally rod rosa kernel shell; done > palabras.txt; }
extra_check() { must_use tee; max_lines 1; }
