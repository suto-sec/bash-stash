# checker spec for 1510 (see lib/engine.sh)
SEEDS=5
input() { echo "$(word)"; pick 20 33 abc 7 99 ''; }
extra_check() { must_use read; }
