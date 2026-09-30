# checker spec for 0421 (see lib/engine.sh)
SCRIPT_NAME=tar_countext.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p paquete/sub
  local exts=(txt log c sh) i n; n=$(randr 6 10)
  for i in $(seq "$n"); do
    randtext "$(randr 1 3)" > "paquete/$(word)$i.$(pick "${exts[@]}")"
  done
  randtext 1 > "paquete/sub/$(word).dat"
  randtext 1 > "paquete/archivo con espacios.txt"
  touch paquete/sinext
  tar -cf plano.tar paquete
  tar -czf comprimido.tgz paquete
  echo "esto no es un tar" > roto.tar
}
ARGS=(
  ''
  'plano.tar extra'
  'noexiste.tar'
  'roto.tar'
  'plano.tar'
  'comprimido.tgz'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *tar_countext.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
