# checker spec for 1530 (see lib/engine.sh)
SCRIPT_NAME=inventario.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  local f i
  for f in inventario.csv "almacen 2.csv" limpio.csv; do
    echo "producto;cantidad;precio" > "$f"
    for i in $(seq "$(randr 3 8)"); do
      if [[ $f != limpio.csv && $(rand 4) == 0 ]]; then
        pick "x;;3" "$(word);abc;2" ";3;4" "$(word)" "$(word);1;2;9" "$(word);-1;2" "$(word) $(word);5"
      else
        echo "$(pick "$(word)" "$(word) $(word)" "$(word) M$(randr 2 12)");$(randr 0 20);$(randr 1 50)"
      fi
    done >> "$f"
  done
}
ARGS=('inventario.csv' '"almacen 2.csv" 10' 'limpio.csv 0' 'limpio.csv' '"almacen 2.csv"' ''
      'a b c' 'nada.csv' 'limpio.csv x' 'limpio.csv -3')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  true
}
