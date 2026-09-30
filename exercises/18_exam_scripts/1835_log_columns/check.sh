# checker spec for 1835 (see lib/engine.sh)
SCRIPT_NAME=log_columns.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  local i lvl
  : > acceso.log
  for i in $(seq 20); do
    lvl=$(pick INFO ERROR WARN INFO DEBUG)
    echo "2026-06-1$(rand 9) $lvl mensaje $(word) $i" >> acceso.log
  done
  cp acceso.log "acceso con espacio.log"
  touch vacio.log
  touch privado.log
  chmod 000 privado.log
  mkdir carpeta.log
}
ARGS=('' 'acceso.log extra' 'acceso.log' 'noexiste.log' 'privado.log' 'vacio.log' '"acceso con espacio.log"' 'carpeta.log')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *log_columns.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
