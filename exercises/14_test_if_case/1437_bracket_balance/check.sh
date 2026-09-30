# checker spec for 1437 (see lib/engine.sh)
SCRIPT_NAME=balance.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('' '"()"' '"(())"' '"((()))"' '")"' '"("' '"()()"' '"(()"' '"())"' '"(a)"' '"abc"' '"((())))"')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ ${#a[@]} -eq 1 && $REF_CODE == 2 ]] && mentions "${a[0]}"
}
