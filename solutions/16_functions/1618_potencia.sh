#!/bin/bash
# potencia.sh BASE EXP
if [ $# -ne 2 ]; then
  echo "usage: $(basename "$0") BASE EXP" >&2
  exit 1
fi
BASE=$1
EXP=$2
if [[ ! $BASE =~ ^-?[0-9]+$ ]]; then
  echo "error: '$BASE' is not a valid integer" >&2
  exit 2
fi
if [[ ! $EXP =~ ^[0-9]+$ ]]; then
  echo "error: '$EXP' is not a valid non-negative integer" >&2
  exit 3
fi
if [ "$EXP" -gt 15 ]; then
  echo "error: exponent '$EXP' is too large (max 15)" >&2
  exit 4
fi

potencia() {
  local b=$1 e=$2
  if [ "$e" -eq 0 ]; then
    echo 1
  else
    echo "$(( b * $(potencia "$b" $((e - 1))) ))"
  fi
}
suma_digitos() {
  local n=$1
  if [ "$n" -lt 10 ]; then
    echo "$n"
  else
    echo "$(( n % 10 + $(suma_digitos $((n / 10))) ))"
  fi
}

R=$(potencia "$BASE" "$EXP")
abs=$R
[ "$abs" -lt 0 ] && abs=$((-abs))
D=$(suma_digitos "$abs")
echo "$BASE^$EXP = $R"
echo "digit sum of |R|: $D"

