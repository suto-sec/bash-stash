# checker spec for 1009 (see lib/engine.sh)
COMPARE="stdout exit files"
setup() { local i; for i in $(seq 4); do echo "$(word)$i/$(pick src doc)"; done > dirs.txt; for i in 1 2 3; do echo "$(randr 1 99) $(randr 1 99) $(randr 1 99)"; done > numeros.txt; }
extra_check() { must_use xargs; }
