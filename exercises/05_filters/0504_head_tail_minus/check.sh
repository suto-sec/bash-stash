# checker spec for 0504 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 8 15)"); do echo "$i $(words 3)"; done > datos.txt; }
