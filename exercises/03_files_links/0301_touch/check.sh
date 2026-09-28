# checker spec for 0301 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { mkdir docs; }
extra_check() { max_lines 1; must_use touch; }
