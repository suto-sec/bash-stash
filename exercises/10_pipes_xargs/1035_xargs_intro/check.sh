# checker spec for 1035 (see lib/engine.sh)
SEEDS=1
setup() { mkfl nombres.txt "$(word)" "$(word)" "$(word)"; }
extra_check() { must_use xargs; }
