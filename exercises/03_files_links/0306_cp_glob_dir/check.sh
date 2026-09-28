# checker spec for 0306 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir -p Inversiones old; local i; for i in 1 2 3; do randtext 2 > "$(word)$i.txt"; randtext 2 > "old/$(word)$i.txt"; touch "$(word)$i.csv"; done; }
extra_check() { max_lines 1; }
