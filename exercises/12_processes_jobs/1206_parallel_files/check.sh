# checker spec for 1206 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { mkdir datos; local i; for i in $(seq "$(randr 2 6)"); do randtext "$(randr 1 30)" > "datos/$(word)$i.txt"; done; }
extra_check() { must_use wait; }
