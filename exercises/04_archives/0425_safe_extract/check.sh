# checker spec for 0425 (see lib/engine.sh)
SCRIPT_NAME=safe_extract.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p chico/sub grande/sub
  local i
  for i in 1 2 3; do bigfile "chico/sub/$(pick "$(word)$i.dat" "$(word) $i.dat")" "$(randr 100 500)"; done
  for i in 1 2 3 4; do bigfile "grande/sub/$(pick "$(word)$i.dat" "$(word) $i.dat")" "$(randr 50000 90000)"; done
  tar -czf chico.tar.gz chico
  tar -czf grande.tar.gz grande
  echo basura > roto.tar.gz
  mkdir "ya existe"
  touch fich
}
ARGS=(
  'chico.tar.gz salida1 100000'
  'grande.tar.gz salida2 100000'
  'grande.tar.gz salida3 1000000'
  'chico.tar.gz "ya existe" 100000'
  'chico.tar.gz salida4'
  'chico.tar.gz salida4 100000 extra'
  'noexiste.tar.gz salida5 100000'
  'roto.tar.gz salida6 100000'
  'chico.tar.gz salida7 abc'
  'chico.tar.gz salida8 -1'
  ''
)
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$3")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$3")" ;;
  esac
}
