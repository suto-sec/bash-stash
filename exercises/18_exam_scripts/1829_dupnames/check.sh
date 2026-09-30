# checker spec for 1829 (see lib/engine.sh)
SCRIPT_NAME=dupnames.sh
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p uno dos
  touch uno/comun1 dos/comun1
  touch uno/comun2 dos/comun2
  touch "uno/con espacio" "dos/con espacio"
  local i
  for i in $(seq 4); do touch "uno/$(word)$i"; done
  for i in $(seq 4); do touch "dos/$(word)$i"; done
  touch uno/.oculto dos/.oculto
  mkdir uno/sub dos/sub
  touch soloarchivo
}
ARGS=('' 'uno' 'uno dos extra' 'noexiste dos' 'uno noexiste' 'soloarchivo dos' 'uno soloarchivo' 'uno dos')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
