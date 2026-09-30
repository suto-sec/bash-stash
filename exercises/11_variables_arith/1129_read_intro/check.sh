# checker spec for 1129 (see lib/engine.sh)
SEEDS=1
setup() { mkfl dato.txt "$(word)"; }
extra_check() { must_use read; }
