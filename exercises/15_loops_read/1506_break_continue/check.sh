# checker spec for 1506 (see lib/engine.sh)
SEEDS=1
ARGS=('1 2 3' '4 -1 5 0 6' '0 1 2' '-1 -2 -3' '7 8 -9 10 0 11 12')
extra_check() { must_use break continue; }
