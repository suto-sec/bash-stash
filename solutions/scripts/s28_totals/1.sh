#!/bin/bash
total=0
while IFS=: read -r cat amount; do
  [[ -n $cat ]] || continue
  total=$((total + amount))
done < "$1"
echo "TOTAL: $total"
