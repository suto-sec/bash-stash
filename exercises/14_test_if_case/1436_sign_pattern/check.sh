# checker spec for 1436 (see lib/engine.sh)
SEEDS=1
ARGS=('1 2 3' '-1 -2 -3' '0 0 0' '1 -2 3' '1 0 -3' '0 5 9' '-5 -5 0' '7 -7 0')
extra_check() { must_use case; }
