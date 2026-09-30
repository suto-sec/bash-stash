# checker spec for 0562 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 5 10)"); do echo "$(word):$(randr 1 99):$(word)"; done > datos.txt; }
extra_check() { must_use cut; }
