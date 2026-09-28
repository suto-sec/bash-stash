# checker spec for 1011 (see lib/engine.sh)
SEEDS=1
filter() { grep -v ' alumno$'; }
extra_check() { max_lines 1; }
