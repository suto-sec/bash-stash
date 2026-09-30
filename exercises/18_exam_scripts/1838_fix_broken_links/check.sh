# checker spec for 1838 (see lib/engine.sh)
SCRIPT_NAME=fix_broken_links.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/sub "d/con espacio"
  touch d/real.txt
  ln -s real.txt d/valido1
  ln -s "$(pwd)/d/real.txt" d/sub/valido2
  ln -s noexiste.txt d/roto1
  ln -s /no/existe/nunca "d/con espacio/roto2"
  ln -s otronoexiste d/sub/roto3
  touch archivo_no_dir
}
ARGS=('' 'd extra' 'd' 'noexiste' 'archivo_no_dir' 'd/sub')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *fix_broken_links.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
