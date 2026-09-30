# checker spec for 1613 (see lib/engine.sh)
SEEDS=1
ARGS=('5' '1 2 3' '' '10 -3 7 2' '4 4 4 4')
extra_check() { must_use local; }
