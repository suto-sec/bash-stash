# checker spec for 2012 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq "$(randr 12 20)"); do echo "$i $(word)"; done > registro.txt; }
extra_check() { must_use head tail; }
