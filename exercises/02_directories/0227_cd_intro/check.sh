# checker spec for 0227 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p a/b; }
extra_check() { must_use cd; }
