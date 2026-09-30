# checker spec for 0418 (see lib/engine.sh)
SCRIPT_NAME=tar_grep.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p paquete/docs paquete/src
  local i n; n=$(randr 3 5)
  for i in $(seq "$n"); do randtext 2 > "paquete/docs/$(word)$i.txt"; done
  local k=$(randr 1 3) j
  for j in $(seq "$k"); do
    echo "linea $(word) con PALABRA_CLAVE dentro" > "paquete/src/$(word)$j.txt"
  done
  echo "no coincide con nada de esto" > "paquete/src/normal.txt"
  echo "aqui tambien hay PALABRA_CLAVE" > "paquete/docs/archivo con espacios $(word).txt"
  tar -czf paquete.tgz paquete
  rm -rf paquete
  echo basura > roto.tgz
}
ARGS=(
  ''
  'paquete.tgz'
  'paquete.tgz PALABRA_CLAVE extra'
  'noexiste.tgz PALABRA_CLAVE'
  'roto.tgz PALABRA_CLAVE'
  'paquete.tgz PALABRA_CLAVE'
  'paquete.tgz NOEXISTE_PATRON'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *tar_grep.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
