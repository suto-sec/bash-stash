# checker spec for 0753 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p tree/{a,b/c}; touch tree/a/f1 tree/b/f2 tree/b/c/f3 tree/root.txt; }
