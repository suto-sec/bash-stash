# checker spec for 2010 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 8 14)"); do echo "$i $(word)"; done > datos.txt; }
extra_check() { must_use head; }
