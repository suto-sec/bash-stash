# checker spec for 0644 (see lib/engine.sh)
SEEDS=1
setup() { local i; for i in $(seq "$(randr 6 10)"); do echo "$(pick rojo azul verde amarillo) $(word)"; done > colores.txt; }
extra_check() { must_use grep; }
