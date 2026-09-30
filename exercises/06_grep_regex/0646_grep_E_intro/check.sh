# checker spec for 0646 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 6 10)"); do echo "$(pick gato perro pajaro pez) $(word)"; done > mascotas.txt; }
extra_check() { must_use grep; }
