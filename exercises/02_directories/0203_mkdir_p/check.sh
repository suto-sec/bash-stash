# checker spec for 0203 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
extra_check() { max_lines 1; must_use mkdir; }
