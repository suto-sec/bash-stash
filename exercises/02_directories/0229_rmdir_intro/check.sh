# checker spec for 0229 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout exit files"
setup() { mkdir vacio otro; }
extra_check() { must_use rmdir; must_not_use rm; }
