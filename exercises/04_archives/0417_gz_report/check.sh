# checker spec for 0417 (see lib/engine.sh)
SCRIPT_NAME=gz_report.sh
SEEDS=2
COMPARE="stdout exit errmsg files"
setup() {
  mkdir -p datos/sub
  local i n; n=$(randr 2 4)
  for i in $(seq "$n"); do
    randtext "$(randr 1 6)" > "datos/$(word)$i.txt"
  done
  for f in datos/*.txt; do gzip "$f"; done
  randtext 3 > "datos/notas de clase.txt"
  gzip "datos/notas de clase.txt"
  randtext 2 > "datos/sub/anidado.txt"
  gzip "datos/sub/anidado.txt"
  echo plano > datos/plano.txt
  echo x > datos/falso.gz.txt
  mkdir -p vacio
}
ARGS=(
  ''
  'datos extra'
  'noexiste'
  'datos/plano.txt'
  'datos'
  'vacio'
  '"$W/datos"'
)
extra_check() {
  case $REF_CODE in
    1) [[ $ERR == *gz_report.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the usage message should show how to call the script" ;;
    2|3) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
