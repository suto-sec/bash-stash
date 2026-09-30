# checker spec for 0564 (see lib/engine.sh)
SEEDS=1
setup() { local n w; n=$(randr 3 5); { for i in $(seq "$n"); do w=$(word); echo "$w"; echo "$w"; done; } | sort > lista.txt; }
extra_check() { must_use uniq; }
