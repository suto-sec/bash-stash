# checker spec for 1841 (see lib/engine.sh)
SCRIPT_NAME=du_alert.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/a "d/con espacio"
  bigfile d/a/f1 4096
  bigfile d/a/f2 10240
  bigfile "d/con espacio/f3" 20480
  bigfile d/f4 1024
  bigfile d/f5 5120
  touch archivo_no_dir
}
ARGS=('' 'd' 'd 5 extra' 'noexiste 5' 'archivo_no_dir 5' 'd abc' 'd 5' 'd 100' 'd 3')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *du_alert.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
