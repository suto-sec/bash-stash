# checker spec for 1827 (see lib/engine.sh)
SCRIPT_NAME=csvcol.sh
COMPARE="stdout exit errmsg"
setup() {
  mkfl datos.csv \
    "$(word),$(word),$(randr 1 99),$(word)" \
    "$(word),$(word),$(randr 1 99),$(word)" \
    "$(word),$(word)" \
    "$(word),$(word),$(randr 1 99),$(word),$(word)"
  cp datos.csv "datos con espacio.csv"
  touch novalido.csv
  chmod 000 novalido.csv
  mkdir carpeta.csv
}
ARGS=('' 'datos.csv' 'datos.csv 0' 'datos.csv abc' 'datos.csv 1' 'datos.csv 3' 'datos.csv 5' 'novalido.csv 1' 'noexiste.csv 1' '"datos con espacio.csv" 2' 'carpeta.csv 1' 'a b c')
extra_check() {
  case $REF_CODE in
    1) [[ -n $ERR ]] || fail "expected a usage message on stderr" ;;
    2) mentions "$(eval "set -- $CASE"; echo "$1")" ;;
  esac
}
