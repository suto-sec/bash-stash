# checker spec for 1831 (see lib/engine.sh)
SCRIPT_NAME=splitlines.sh
COMPARE="stdout exit errmsg files"
setup() {
  local i
  : > texto.txt
  for i in $(seq 12); do echo "$(words 3)" >> texto.txt; done
  cp texto.txt "texto con espacio.txt"
  touch vacio.txt
  touch noleible.txt
  chmod 000 noleible.txt
}
ARGS=('' 'texto.txt' 'texto.txt 4 extra' 'texto.txt 4' 'texto.txt 100' 'texto.txt 0' 'texto.txt abc' 'noleible.txt 3' 'noexiste.txt 3' '"texto con espacio.txt" 5' 'vacio.txt 3')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
