# checker spec for 0559 (see lib/engine.sh)
SEEDS=1
setup() { randtext 3 > nota.txt; }
extra_check() { must_use cat; }
