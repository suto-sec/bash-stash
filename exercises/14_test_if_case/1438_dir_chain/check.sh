# checker spec for 1438 (see lib/engine.sh)
SCRIPT_NAME=dir_chain.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() { mkdir -p "nivel uno/nivel dos/nivel tres" "otro_$(word)"; touch "nivel uno/archivo.txt" archivo.txt; }
ARGS=('' 'noexiste' '"nivel uno"' '"nivel uno" "nivel dos"' '"nivel uno" "nivel dos" "nivel tres"' '"nivel uno" noexiste' '"nivel uno" "nivel dos" noexiste' 'archivo.txt')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[$((${#a[@]} - 1))]}"
}
