# checker spec for 1337 (see lib/engine.sh)
SEEDS=1
ARGS=('' '0' '1' '0 0 0' '0 0 1 0' '5 0 0' '0 1 2 3' '255' '0 0 0 0 0')
extra_check() { must_use break; }
