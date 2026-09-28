# checker spec for 0520 (see lib/engine.sh)
setup() { local i; for i in $(seq 8); do words 3; done > v1.txt; cp v1.txt copia.txt; sed "$(randr 2 7)s/.*/$(words 2)/; $(randr 1 8)d" v1.txt > v2.txt; echo "$(word)" >> v2.txt; }
