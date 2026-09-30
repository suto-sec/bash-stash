# checker spec for 0558 (see lib/engine.sh)
SCRIPT_NAME=chunkjoin.sh
SEEDS=2
COMPARE="stdout exit errmsg"
ARGS=('datos.txt 3' 'datos.txt 1' 'impar.txt 4' 'datos.txt' 'datos.txt 3 x' 'nofile.txt 3' 'datos.txt abc' 'datos.txt 0')
setup() {
  local n i
  n=$(( 3 * $(randr 4 8) ))
  : > datos.txt
  for i in $(seq "$n"); do echo "$(word)$i"; done > datos.txt
  n=$(pick 5 6 7 9 10 11 13 14)
  : > impar.txt
  for i in $(seq "$n"); do echo "$(word)"; done > impar.txt
}
extra_check() {
  [[ -n $REF_ERR && -n $OUT ]] && fail "on errors nothing must be printed on stdout"
  case $REF_CODE in
    1) [[ $ERR == *chunkjoin.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
