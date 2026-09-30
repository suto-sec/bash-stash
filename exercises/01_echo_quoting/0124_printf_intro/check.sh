# checker spec for 0124 (see lib/engine.sh)
SEEDS=1
extra_check() { must_use printf; must_not_use echo; }
