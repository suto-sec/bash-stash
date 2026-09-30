#!/bin/bash
# clasificar.sh NUM...
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") NUM..." >&2
  exit 1
fi

source ./lib_num.sh

pos=0; neg=0; cero=0; inv=0
for n in "$@"; do
  if ! es_numero "$n"; then
    echo "$n: no numero"
    inv=$((inv + 1))
    continue
  fi
  if [ "$n" -eq 0 ]; then
    echo "$n: cero"
    cero=$((cero + 1))
    continue
  fi
  if [ "$n" -gt 0 ]; then signo=positivo; pos=$((pos + 1)); else signo=negativo; neg=$((neg + 1)); fi
  if es_par "$n"; then paridad=par; else paridad=impar; fi
  echo "$n: $signo $paridad"
done
echo "TOTAL: $pos positivos, $neg negativos, $cero ceros, $inv invalidos"

