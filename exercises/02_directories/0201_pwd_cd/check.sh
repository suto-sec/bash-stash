# checker spec for 0201 (see lib/engine.sh)
SEEDS=1
setup() { mkdir -p a/b/c; }
extra_check() { must_use cd pwd; must_use '\.\.'; }
