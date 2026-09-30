# checker spec for 0563 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 6 12)"); do word; done > nombres.txt; }
extra_check() { must_use sort; }
