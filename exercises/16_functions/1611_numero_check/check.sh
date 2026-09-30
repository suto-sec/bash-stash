# checker spec for 1611 (see lib/engine.sh)
SEEDS=1
ARGS=('5' '-5' 'abc' '' '007 -3 4.5 x1 10 -0' '1 2 3 4 5' '0')
extra_check() { must_use return; }
