# checker spec for 1834 (see lib/engine.sh)
SCRIPT_NAME=archive_recent.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p proyecto/src "proyecto/con espacio" dest vacio
  touch -d '1 days ago' proyecto/src/reciente1.log
  touch -d '3 days ago' proyecto/src/reciente2.log
  touch -d '10 days ago' proyecto/viejo1.log
  touch -d '20 days ago' "proyecto/con espacio/viejo2.log"
  local i
  for i in $(seq 4); do touch -d "$(pick 1 2 8 15 25) days ago" "proyecto/$(pick . src)/$(word)$i.dat"; done
  touch archivo_no_dir
}
ARGS=('' 'proyecto' 'proyecto 5' 'proyecto 5 dest extra' 'noexiste 5 dest' 'archivo_no_dir 5 dest' 'proyecto abc dest' 'proyecto 5 dest' 'vacio 5 dest' 'proyecto 5 "$W/nuevodest"')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *archive_recent.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
    5) [[ -n $ERR ]] || fail "expected an error message on stderr" ;;
  esac
}
