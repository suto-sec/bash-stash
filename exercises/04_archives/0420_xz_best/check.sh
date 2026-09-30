# checker spec for 0420 (see lib/engine.sh)
SCRIPT_NAME=xz_best.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p zona/sub
  local i n; n=$(randr 3 5)
  for i in $(seq "$n"); do
    if [[ $(rand 2) == 0 ]]; then
      randtext "$(randr 20 60)" > "zona/$(word)$i.dat"
    else
      bigfile "zona/$(word)$i.dat" "$(randr 200 800)"
    fi
  done
  randtext 3 > "zona/archivo con espacios $(word).dat"
  randtext 2 > zona/sub/anidado.dat
  randtext 2 > marcador.txt
  mkdir vacio
}
ARGS=(
  ''
  'zona extra'
  'noexiste'
  'marcador.txt'
  'zona'
  'vacio'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *xz_best.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
