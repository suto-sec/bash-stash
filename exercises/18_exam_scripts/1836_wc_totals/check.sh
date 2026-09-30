# checker spec for 1836 (see lib/engine.sh)
SCRIPT_NAME=wc_totals.sh
SEEDS=2
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  mkfl d/a.txt "linea uno" "linea dos"
  mkfl d/sub/b.txt "$(words 3)"
  mkfl "d/con espacio/c.txt" "$(words 5)" "$(words 2)" "$(words 1)"
  touch d/vacio.txt
  echo otro > d/notme.dat
  mkdir d/carpeta.txt
  touch archivo_no_dir
}
ARGS=('' 'd' 'd txt extra' 'noexiste txt' 'archivo_no_dir txt' 'd txt' 'd dat' 'd zzz')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *wc_totals.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
