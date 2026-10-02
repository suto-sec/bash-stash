# checker spec for 2008 (see lib/engine.sh)
SEEDS=3
setup() { local i w; for i in $(seq "$(randr 9 14)"); do w=$(word); echo "$w"; (( $(rand 3) == 0 )) && echo "$w"; done > nombres.txt; head -n 1 nombres.txt >> nombres.txt; echo "$(word)" >> nombres.txt; }
extra_check() { must_use uniq; }
