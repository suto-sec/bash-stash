# checker spec for 0117 (see lib/engine.sh)
SEEDS=4
setup() { randr 3 15 > n.txt; }
extra_check() { must_not_use for while until; }
