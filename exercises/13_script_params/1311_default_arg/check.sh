# checker spec for 1311 (see lib/engine.sh)
SEEDS=2
setup() { mkdir -p sub; local i; for i in $(seq 6); do touch "$(word)$i" "sub/$(word)$i"; done; }
ARGS=('' 'sub' 'sub 5' '. 1')
