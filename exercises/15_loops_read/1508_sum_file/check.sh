# checker spec for 1508 (see lib/engine.sh)
setup() { local i; for i in $(seq 12); do echo "$(pick comida casa ocio transporte) $(randr 1 200)"; done > gastos.txt; }
