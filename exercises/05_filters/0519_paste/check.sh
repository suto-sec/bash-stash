# checker spec for 0519 (see lib/engine.sh)
setup() { local n i; n=$(randr 3 7); for i in $(seq "$n"); do word; done > nombres.txt; for i in $(seq "$n"); do randr 18 70; done > edades.txt; }
