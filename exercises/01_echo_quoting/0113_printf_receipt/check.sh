# checker spec for 0113 (see lib/engine.sh)
SEEDS=4
setup() { echo "$(word) $(randr 1 60) $(pick "$(randr 1 99)" "$(randr 100 9999)" "$(randr 10000 99999)")" > order.txt; }
extra_check() { must_use printf; }
