# checker spec for 1830 (see lib/engine.sh)
SCRIPT_NAME=countperm.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  touch d/a1 d/a2 d/sub/b1 "d/con espacio/c1" d/b2 d/c3
  chmod 644 d/a1 d/a2
  chmod 755 d/sub/b1
  chmod 600 "d/con espacio/c1"
  chmod 4755 d/b2
  chmod 700 d/c3
  touch archivo_no_dir
}
ARGS=('' 'd' 'd 644 extra' 'd 644' 'd 755' 'd 600' 'd 4755' 'd 999' 'd abc' 'noexiste 644' 'archivo_no_dir 644')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
