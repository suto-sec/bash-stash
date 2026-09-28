# checker spec for 1103 (see lib/engine.sh)
setup() { local i; for i in $(seq "$(randr 3 9)"); do randr 0 10; done > notas.txt; }
extra_check() { must_use bc; }
