# checker spec for 0522 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in $(seq "$(randr 21 55)"); do echo "$i $(words 2)"; done > grande.txt; }
