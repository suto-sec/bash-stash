# checker spec for 1443 (see lib/engine.sh)
SEEDS=1
ARGS=('5' '-3' '0')
extra_check() { must_use if elif; }
