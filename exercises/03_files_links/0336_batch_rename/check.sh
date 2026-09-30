# checker spec for 0336 (see lib/engine.sh)
SCRIPT_NAME=batch_rename.sh
SEEDS=3
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p "proy/src" "proy/old bin"
  local i f
  for i in 1 2 3 4 5; do
    f="proy/$(pick . src "old bin")/$(pick "$(word)$i" "$(word) $i")"
    randtext 1 > "$f.bak"
  done
  randtext 1 > "proy/src/paquete.tar.bak"
  randtext 1 > "proy/colision.bak"
  randtext 1 > "proy/colision.txt"
  randtext 1 > "proy/old bin/otro.bak"
  randtext 1 > "proy/old bin/otro.old"
  randtext 2 > "proy/normal.txt"
  mkdir "proy/vacio.bak"
  touch fich
}
ARGS=(
  'proy bak txt'
  '"$W/proy" bak old'
  '"proy/old bin" bak done'
  'proy bak'
  'proy bak bak2 extra'
  'noexiste bak txt'
  'fich bak txt'
  'proy "" txt'
  'proy bak "a/b"'
  ''
)
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
