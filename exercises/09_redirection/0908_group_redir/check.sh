# checker spec for 0908 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir docs; local i; for i in $(seq "$(randr 1 5)"); do touch "docs/$(word)$i.txt" "docs/$(word)$i.md"; done; }
