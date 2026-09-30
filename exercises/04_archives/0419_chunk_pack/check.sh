# checker spec for 0419 (see lib/engine.sh)
SCRIPT_NAME=chunk_pack.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  bigfile "grande.dat" "$(randr 2000 6000)"
  mkdir carpeta
  randtext 2 > carpeta/nota.txt
}
ARGS=(
  ''
  'grande.dat'
  'grande.dat 500 extra'
  'noexiste.dat 500'
  'carpeta 500'
  'grande.dat abc'
  'grande.dat 0'
  'grande.dat 500'
  'grande.dat 100000'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *chunk_pack.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
    4) mentions "$(eval "set -- $CASE"; echo "$2")" ;;
  esac
}
