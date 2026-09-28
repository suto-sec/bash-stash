# checker spec for 0712 (see lib/engine.sh)
setup() { mkdir -p "docs/mis cosas"; local i; for i in $(seq 5); do randtext "$(randr 1 9)" > "docs/$(pick . 'mis cosas')/$(word) $(pick '' 'copia ' '')$i.txt"; done; }
