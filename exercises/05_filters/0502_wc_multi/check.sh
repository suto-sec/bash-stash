# checker spec for 0502 (see lib/engine.sh)
setup() { local i; for i in 1 2 3; do randtext "$(randr 1 20)" > "$(word)$i.txt"; done; randtext 3 > other.md; }
