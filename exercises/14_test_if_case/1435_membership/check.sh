# checker spec for 1435 (see lib/engine.sh)
SEEDS=1
ARGS=('x' 'x a b' 'a x b' 'a b x' 'a b c' 'x' 'ab a ab b' 'a a a')
extra_check() { must_use case break; }
