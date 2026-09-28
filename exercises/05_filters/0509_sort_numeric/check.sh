# checker spec for 0509 (see lib/engine.sh)
setup() { local i; for i in $(seq 12); do randr 1 5000; done > numeros.txt; for i in $(seq 8); do echo "$(randr 1 900)$(pick K M G)"; done > tamanos.txt; }
