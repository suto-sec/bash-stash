# checker spec for 0756 (see lib/engine.sh)
COMPARE="stdout exit files"
SEEDS=1
setup() { mkdir -p scripts/sub; touch scripts/a.sh scripts/b.sh scripts/sub/c.sh scripts/d.txt; }
extra_check() { must_use -exec; }
