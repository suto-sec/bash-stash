# checker spec for 1118 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 8 14)"); do word; done > palabras.txt; }
extra_check() { must_use declare; }
