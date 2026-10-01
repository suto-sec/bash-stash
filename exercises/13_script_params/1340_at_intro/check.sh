# checker spec for 1340 (see lib/engine.sh)
SEEDS=1
ARGS=('' 'uno' 'uno dos tres' '"a b" c')
extra_check() { must_use for; }
