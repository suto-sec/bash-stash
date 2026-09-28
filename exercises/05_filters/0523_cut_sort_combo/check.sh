# checker spec for 0523 (see lib/engine.sh)
setup() { echo "fecha,producto,unidades,precio" > ventas.csv; local i; for i in $(seq 12); do echo "2026-0$(randr 1 9)-1$(randr 0 9),$(word),$(randr 1 300),$(randr 1 99).$(randr 10 99)"; done >> ventas.csv; }
