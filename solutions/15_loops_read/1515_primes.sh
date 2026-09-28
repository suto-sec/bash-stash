#!/bin/bash
out=()
for ((n = 2; n <= $1; n++)); do
  p=1
  for ((d = 2; d * d <= n; d++)); do
    (( n % d == 0 )) && { p=0; break; }
  done
  (( p )) && out+=("$n")
done
echo "${out[*]}"

