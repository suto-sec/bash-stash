# checker spec for 1403 (see lib/engine.sh)
SEEDS=1
ARGS=('1 2 3' '3 2 1' '2 3 1' '5 5 1' '-4 -2 -9' '7 7 7' '10 9 100')
extra_check() { must_not_use sort; }
