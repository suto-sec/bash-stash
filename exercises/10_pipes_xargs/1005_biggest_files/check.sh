# checker spec for 1005 (see lib/engine.sh)
setup() { mkdir -p datos/{a,b,c}; local i; for i in $(seq 6); do bigfile "datos/$(word)$i" $(( $(randr 1 200) * 512 + i )); done; for i in a b c; do bigfile "datos/$i/f" $(( $(randr 1 50) * 4096 )); done; }
