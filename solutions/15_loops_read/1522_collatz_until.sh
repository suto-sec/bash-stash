#!/bin/bash
n=$1; seq=$n; s=0; max=$n
until [ "$n" -eq 1 ]; do
  if (( n % 2 == 0 )); then n=$((n / 2)); else n=$((3 * n + 1)); fi
  seq+=" $n"; s=$((s + 1))
  [ "$n" -gt "$max" ] && max=$n
done
echo "$seq"
echo "steps: $s, max: $max"

