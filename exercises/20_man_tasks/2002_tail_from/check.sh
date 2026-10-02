# checker spec for 2002 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 8 15)"); do echo "$i $(word)"; done > registro.txt; }
extra_check() { must_use tail; }
