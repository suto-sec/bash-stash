# checker spec for 1612 (see lib/engine.sh)
SEEDS=1
ARGS=('5' '3 9 1' '-5 -1 -10' '7 7 7' '10 -20 30 0')
extra_check() { must_use read; }
