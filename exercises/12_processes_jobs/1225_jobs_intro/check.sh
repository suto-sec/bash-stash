# checker spec for 1225 (see lib/engine.sh)
SEEDS=1
filter() { sed 's/  */ /g'; }
extra_check() { must_use jobs; }
