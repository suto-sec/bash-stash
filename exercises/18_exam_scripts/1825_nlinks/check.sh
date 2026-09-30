# checker spec for 1825 (see lib/engine.sh)
SCRIPT_NAME=nlinks.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p d/sub "d/con espacio"
  touch d/original1
  ln d/original1 d/copia1
  local i f g
  for i in $(seq 5); do
    f="d/$(pick . sub 'con espacio')/$(word)$i"
    touch "$f"
    if [[ $(rand 2) == 1 ]]; then
      g="d/$(pick . sub)/$(word)link$i"
      ln "$f" "$g"
    fi
  done
  touch solo
}
ARGS=('' 'd' 'd extra' 'noexiste' 'solo' 'd/sub')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "${1:-.}")" ;;
  esac
}
