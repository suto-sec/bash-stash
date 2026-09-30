# checker spec for 0836 (see lib/engine.sh)
COMPARE="stdout exit files"
SEEDS=1
setup() { touch datos.txt; chmod 777 datos.txt; }
extra_check() { must_use chmod; }
