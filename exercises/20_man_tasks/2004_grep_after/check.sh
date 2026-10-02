# checker spec for 2004 (see lib/engine.sh)
SEEDS=3
setup() { local i; for i in $(seq 14); do if (( $(rand 5) == 0 )); then echo "$(word) ERROR $(word)"; else echo "$(word) $(pick INFO WARN DEBUG) $(word)"; fi; done > servicio.log; grep -q ERROR servicio.log || sed -i '5s/.*/disco ERROR lleno/' servicio.log; }
extra_check() { must_use grep; }
