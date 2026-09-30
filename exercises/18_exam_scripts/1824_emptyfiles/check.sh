# checker spec for 1824 (see lib/engine.sh)
SCRIPT_NAME=emptyfiles.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  local i f
  for i in $(seq 8); do
    f="d/$(pick . sub 'con espacio')/$(word)$i"
    if [[ $(rand 2) == 1 ]]; then : > "$f"; else echo "$(word)" > "$f"; fi
  done
  mkdir -p d/vacio_dir
  ln -s "$(word)" d/enlace_roto
  touch nodir
}
ARGS=('' 'd' 'd extra' 'noexiste' 'nodir' 'd/sub')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "${1:-.}")" ;;
  esac
}
