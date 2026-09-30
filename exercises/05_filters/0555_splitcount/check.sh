# checker spec for 0555 (see lib/engine.sh)
SCRIPT_NAME=splitcount.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('datos.txt 5' 'datos.txt 7' 'pocas.txt 3' 'pocas.txt 100' 'datos.txt' 'datos.txt 3 x' 'nofile.txt 5' 'datos.txt abc' 'datos.txt 0')
setup() {
  local n i
  n=$(randr 15 40)
  : > datos.txt
  for i in $(seq "$n"); do echo "$(word)"; done > datos.txt
  n=$(randr 5 12)
  : > pocas.txt
  for i in $(seq "$n"); do echo "$(word) $(word)"; done > pocas.txt
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *splitcount.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
