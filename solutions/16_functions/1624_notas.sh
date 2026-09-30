#!/bin/bash
# notas.sh NOTA...
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") NOTA..." >&2
  exit 1
fi

es_valida() {
  if [[ $1 =~ ^[0-9]+$ ]] && [ "$1" -le 100 ]; then
    return 0
  else
    return 1
  fi
}

letra() {
  local n=$1
  if [ "$n" -ge 90 ]; then echo A
  elif [ "$n" -ge 80 ]; then echo B
  elif [ "$n" -ge 70 ]; then echo C
  elif [ "$n" -ge 60 ]; then echo D
  else echo F
  fi
}

validas=0
suma=0
for n in "$@"; do
  if es_valida "$n"; then
    l=$(letra "$n")
    echo "$n: $l"
    validas=$((validas + 1))
    suma=$((suma + n))
  else
    echo "notas.sh: '$n' invalida" >&2
  fi
done

if [ "$validas" -eq 0 ]; then
  echo "error: ninguna nota valida" >&2
  exit 2
fi

promedio=$((suma / validas))
lp=$(letra "$promedio")
echo "TOTAL: $validas validas, promedio $promedio, letra_prom $lp"

