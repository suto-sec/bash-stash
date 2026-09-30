# checker spec for 1036 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { mkfl entrada.txt "$(words 3)"; }
extra_check() { must_use tee; }
