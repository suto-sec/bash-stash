# checker spec for 0901 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir datos; local i; for i in $(seq "$(randr 2 7)"); do touch "datos/$(word)$i"; done; echo "old content" > ultima.txt; }
