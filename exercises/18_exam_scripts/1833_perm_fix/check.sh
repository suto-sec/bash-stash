# checker spec for 1833 (see lib/engine.sh)
SCRIPT_NAME=perm_fix.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p d/sub "d/con espacio"
  touch d/a.sh d/sub/b.sh "d/con espacio/c.sh" d/keep.sh d/notme.txt
  chmod 644 d/a.sh
  chmod 755 d/sub/b.sh
  chmod 600 "d/con espacio/c.sh"
  chmod 755 d/keep.sh
  chmod 644 d/notme.txt
  mkdir d/carpeta.sh
  touch soloarchivo
}
ARGS=('' 'd' 'd 755 extra' 'noexiste 755' 'soloarchivo 755' 'd abc' 'd 9999' 'd 755' 'd 644')
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *perm_fix.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
