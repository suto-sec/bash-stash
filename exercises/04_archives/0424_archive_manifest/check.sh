# checker spec for 0424 (see lib/engine.sh)
SCRIPT_NAME=archive_manifest.sh
SEEDS=3
COMPARE="stdout exit errmsg"
setup() {
  mkdir -p "paquete/sub uno/deep" paquete/otros
  local i f sz
  for i in 1 2 3 4 5 6; do
    f="paquete/$(pick . "sub uno" "sub uno/deep" otros)/$(pick "$(word)$i.dat" "$(word) $i.bin")"
    sz=$(randr 1 9000)
    bigfile "$f" "$sz"
  done
  tar -czf paquete.tar.gz paquete
  echo basura > roto.tar.gz
  touch fich
}
ARGS=(
  'paquete.tar.gz'
  '"$W/paquete.tar.gz"'
  'paquete.tar.gz extra'
  ''
  'noexiste.tar.gz'
  'roto.tar.gz'
  'fich'
)
extra_check() {
  case $REF_CODE in
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
