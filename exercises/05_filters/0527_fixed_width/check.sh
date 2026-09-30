# checker spec for 0527 (see lib/engine.sh)
setup() {
  local i n name; n=$(randr 6 14)
  for ((i = 1; i <= n; i++)); do
    name=$(word); [[ $(rand 2) == 0 ]] && name="$name $(word)"
    printf '%-6s%-20s%5d\n' "P$(randr 100 999)$i" "$name" "$(randr 1 25)"
  done > inventario.txt
}
extra_check() { must_use cut; }
