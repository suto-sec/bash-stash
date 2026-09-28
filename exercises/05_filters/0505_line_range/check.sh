# checker spec for 0505 (see lib/engine.sh)
setup() { local i; for i in $(seq 60); do echo "L$i: $(words 4)"; done > libro.txt; local a; a=$(randr 1 40); echo "$a $((a + $(randr 0 15)))" > rango.txt; }
