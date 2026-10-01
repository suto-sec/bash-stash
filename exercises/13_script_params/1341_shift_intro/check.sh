# checker spec for 1341 (see lib/engine.sh)
SEEDS=1
ARGS=('' 'uno' 'uno dos' 'uno dos tres')
extra_check() { must_use shift; }
