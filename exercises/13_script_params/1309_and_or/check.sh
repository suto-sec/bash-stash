# checker spec for 1309 (see lib/engine.sh)
SEEDS=1
setup() { mkdir yaexiste; touch unfichero; }
ARGS=('nuevo' 'yaexiste' 'unfichero' 'a/b')
extra_check() { must_not_use if; }
