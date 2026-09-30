# checker spec for 1823 (see lib/engine.sh)
SCRIPT_NAME=countext.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  local i f
  for i in $(seq 10); do
    f="d/$(pick . sub 'con espacio')/$(word)$i$(pick .txt .txt .log .sh '')"
    touch "$f"
  done
  mkdir -p d/carpeta.txt
  touch d/rare.txtx d/notxt
  touch nodir
}
ARGS=('' 'd' 'd txt extra' 'd txt' 'd log' 'd sh' 'd zzz' 'noexiste txt' 'nodir txt')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
