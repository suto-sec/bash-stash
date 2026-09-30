# checker spec for 1618 (see lib/engine.sh)
SCRIPT_NAME=potencia.sh
SEEDS=1
COMPARE="stdout exit errmsg"
ARGS=('2 10' '-3 3' '0 0' '5 0' '-2 5' '' '3' '2 3 4' 'x 3' '2 -1' '2 abc' '2 20')
extra_check() {
  local a; eval "a=( $CASE )"
  [[ $REF_CODE == 2 ]] && mentions "${a[0]}"
  [[ $REF_CODE == 3 ]] && mentions "${a[1]}"
  [[ $REF_CODE == 1 && $ERR != *potencia.sh* && $ERR != *sage* ]] && fail "the usage message should show how to call the script"
  true
}
