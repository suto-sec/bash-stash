#!/bin/bash
declare -A CNT SUM MIN MAX
v=0; inv=0
while read -r s val; do
  if [ "$val" -lt -50 ] || [ "$val" -gt 150 ]; then
    echo "$s: lectura invalida ($val)"
    inv=$((inv + 1))
    continue
  fi
  v=$((v + 1))
  CNT[$s]=$(( ${CNT[$s]:-0} + 1 ))
  SUM[$s]=$(( ${SUM[$s]:-0} + val ))
  if [ -z "${MIN[$s]}" ] || [ "$val" -lt "${MIN[$s]}" ]; then MIN[$s]=$val; fi
  if [ -z "${MAX[$s]}" ] || [ "$val" -gt "${MAX[$s]}" ]; then MAX[$s]=$val; fi
done < sensores.txt
for s in "${!CNT[@]}"; do
  echo "$s: ${CNT[$s]} lecturas, min ${MIN[$s]}, max ${MAX[$s]}, media $(( SUM[$s] / CNT[$s] ))"
done | sort
echo "total validas: $v, invalidas: $inv"

