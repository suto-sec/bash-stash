# checker spec for 1540 (see lib/engine.sh)
SEEDS=4
setup() {
  local i pool=() n total
  n=$(randr 3 6)
  for i in $(seq "$n"); do pool+=("$(word)"); done
  total=$(randr 8 14)
  for i in $(seq "$total"); do pick "${pool[@]}"; done > palabras.txt
}
extra_check() {
  ans_code | grep -qE 'declare[[:space:]]+-A' && fail "no associative arrays: use nested loops instead"
}
