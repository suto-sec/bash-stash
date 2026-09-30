# checker spec for 1528 (see lib/engine.sh)
SEEDS=4
setup() { local i; for i in $(seq "$(randr 4 9)"); do randr -5 35; done > temps.txt; }
