# checker spec for 1542 (see lib/engine.sh)
SEEDS=4
setup() {
  local i n exts=(sh txt md jpg png gif dat '') e
  n=$(randr 5 10)
  for i in $(seq "$n"); do
    e=$(pick "${exts[@]}")
    if [ -n "$e" ]; then echo "$(word)$(pick '' ' ')$i.$e"; else echo "$(word)$(pick '' ' ')$i"; fi
  done > entradas.txt
}
extra_check() { must_use case; }
