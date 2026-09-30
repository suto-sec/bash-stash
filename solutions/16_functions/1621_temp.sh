#!/bin/bash
# temp.sh C|F VALOR
die() {
  local code=$1; shift
  echo "ERROR: $*" >&2
  exit "$code"
}

[ $# -eq 2 ] || die 1 "usage: $(basename "$0") C|F VALOR"
UNIDAD=$1
VALOR=$2
[[ $UNIDAD == C || $UNIDAD == F ]] || die 2 "unidad invalida: '$UNIDAD'"
[[ $VALOR =~ ^-?[0-9]+$ ]] || die 3 "valor invalido: '$VALOR'"

c_to_f() { echo $(( $1 * 9 / 5 + 32 )); }
f_to_c() { echo $(( ($1 - 32) * 5 / 9 )); }

convertir() {
  case $1 in
    C) c_to_f "$2" ;;
    F) f_to_c "$2" ;;
  esac
}

R=$(convertir "$UNIDAD" "$VALOR")
if [ "$UNIDAD" = C ]; then OTRA=F; else OTRA=C; fi
echo "$VALOR $UNIDAD = $R $OTRA"

