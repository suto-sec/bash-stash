# checker spec for 0335 (see lib/engine.sh)
SCRIPT_NAME=sync_copy.sh
SEEDS=3
COMPARE="stdout exit errmsg files mtime"
setup() {
  mkdir -p "origen/sub 1/deep" origen/otros
  local i f
  for i in 1 2 3 4 5 6; do
    f="origen/$(pick . "sub 1" "sub 1/deep" otros)/$(pick "$(word)$i.txt" "$(word) $i.dat")"
    randtext "$(randr 1 3)" > "$f"
    touch -d "2023-0$(randr 1 9)-1$(randr 0 8) 1$(randr 0 9):$(randr 10 59)" "$f"
  done
  mkdir -p "copia/sub 1/deep" copia/otros
  while IFS= read -r rel; do
    rel=${rel#./}
    case $(rand 3) in
      0) cp -p "origen/$rel" "copia/$rel" ;;
      1) randtext 1 > "copia/$rel"; touch -d "2025-0$(randr 1 9)-1$(randr 0 8) 1$(randr 0 9):$(randr 10 59)" "copia/$rel" ;;
      2) : ;;
    esac
  done < <(cd origen && find . -type f)
  randtext 1 > copia/solo_destino.txt
  echo hola > fich
}
ARGS=(
  'origen destino1'
  '"origen/sub 1" "destino 2"'
  'origen copia'
  '"$W/origen" "$W/nuevo/hondo"'
  'origen'
  ''
  'noexiste destino3'
  'fich destino4'
  'origen fich'
)
extra_check() {
  case $REF_CODE in
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    3) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
