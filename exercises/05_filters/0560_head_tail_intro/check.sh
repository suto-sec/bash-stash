# checker spec for 0560 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 8 12)"); do echo "$i $(word)"; done > datos.txt; }
