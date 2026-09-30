#!/bin/bash
n=0; total=0; max=-1
while read -r id cliente importe; do
  [ -z "$id" ] && continue                 # blank line
  n=$((n + 1))
  total=$((total + importe))
  if [ "$importe" -gt "$max" ]; then max=$importe; maxid=$id; fi
done < <(grep -v '^#' pedidos.txt)
echo "orders: $n"
echo "total: $total"
echo "max: $maxid ($max)"

