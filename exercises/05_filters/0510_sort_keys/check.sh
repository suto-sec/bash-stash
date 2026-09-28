# checker spec for 0510 (see lib/engine.sh)
setup() { local i; for i in $(seq 12); do echo "$(word)$i:$(pick SO Redes BD Mates):$(randr 0 10)"; done > notas.txt; }
extra_check() { must_use sort; }
