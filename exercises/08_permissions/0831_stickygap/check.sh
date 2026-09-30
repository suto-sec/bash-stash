# checker spec for 0831 (see lib/engine.sh)
SCRIPT_NAME=stickygap.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "arbol/pub/sub compartido" arbol/priv arbol/tmp_ok
  chmod "$(pick 777 775 757)" arbol/pub
  chmod "$(pick 777 773)" "arbol/pub/sub compartido"
  chmod "$(pick 755 700 750)" arbol/priv
  chmod 1777 arbol/tmp_ok
  touch arbol/pub/a "arbol/pub/sub compartido/b"
  chmod 666 arbol/pub/a
  mkdir "carpeta suelta"
  chmod 777 "carpeta suelta"
  touch fich
}
ARGS=(
  'arbol'
  '-f arbol'
  '"$W/arbol"'
  '"carpeta suelta"'
  '-f "carpeta suelta"'
  'arbol/priv'
  '-f'
  '-x arbol'
  'arbol extra'
  'noexiste'
  'fich'
  ''
)
extra_check() {
  case $REF_CODE in
    3) mentions "$(eval "set -- $CASE"; echo "${@: -1}")" ;;
  esac
}
