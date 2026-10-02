# checker spec for 2003 (see lib/engine.sh)
SEEDS=4
setup() { local n=$(randr 5 8) i j line; for i in $(seq 5); do line=$(word); for j in $(seq 2 "$n"); do line+=",$(word)"; done; echo "$line"; done > personas.csv; }
extra_check() { must_use cut; }
