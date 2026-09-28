# checker spec for 1512 (see lib/engine.sh)
setup() { mkdir -p "docs/mis cosas/más"; local i; for i in $(seq 5); do bigfile "docs/$(pick . 'mis cosas' 'mis cosas/más')/$(word) $(pick '' copia 'v 2') $i.txt" "$(randr 0 300)"; done; }
