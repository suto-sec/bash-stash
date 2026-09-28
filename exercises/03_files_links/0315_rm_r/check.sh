# checker spec for 0315 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p pruebatar/a/b; randtext 2 > pruebatar/a/b/f; local i d; for i in 1 2 3 4 5; do d="vacios/$(word)$i"; mkdir -p "$d"; (( i == 1 || $(rand 2) )) && touch "$d/x"; done; mkdir -p vacios/empty0; }
