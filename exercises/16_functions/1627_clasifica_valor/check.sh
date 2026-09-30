# checker spec for 1627 (see lib/engine.sh)
SEEDS=4
setup() {
  local i n
  n=$(randr 6 12)
  for i in $(seq "$n"); do
    pick "$(randr -50 -1)" 0 "$(randr 1 9)" "$(randr 10 99)" "$(randr 100 500)"
  done > medidas.txt
}
extra_check() { must_use clasifica; }
