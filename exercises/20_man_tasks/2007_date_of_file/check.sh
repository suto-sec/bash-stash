# checker spec for 2007 (see lib/engine.sh)
SEEDS=3
setup() { mkf informe.pdf "contenido"; touch -d "$(randr 2019 2025)-$(printf '%02d' "$(randr 1 12)")-$(printf '%02d' "$(randr 1 28)") 15:30" informe.pdf; }
extra_check() { must_use date; }
