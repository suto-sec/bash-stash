# checker spec for 1839 (see lib/engine.sh)
SCRIPT_NAME=org_by_date.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/sub
  touch -d '2026-03-15 10:00' d/a1.txt
  touch -d '2026-03-15 11:00' "d/b con espacio.txt"
  touch -d '2026-04-15 09:00' d/c1.txt
  touch -d '2026-04-15 09:30' d/d1.txt
  touch -d '2026-05-15 08:00' d/e1.txt
  touch -d '2026-04-15 09:00' d/sub/notme.txt
  touch d/.oculto
  touch archivo_no_dir
}
ARGS=('' 'd extra' 'd' 'noexiste' 'archivo_no_dir' 'd/sub')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *org_by_date.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
