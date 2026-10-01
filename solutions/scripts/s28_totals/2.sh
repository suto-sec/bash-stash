#!/bin/bash
declare -A sums
total=0
while IFS=: read -r cat amount; do
  [[ -n $cat ]] || continue
  sums[$cat]=$(( ${sums[$cat]:-0} + amount ))
  total=$((total + amount))
done < "$1"
for c in $(printf '%s\n' "${!sums[@]}" | sort); do
  echo "$c: ${sums[$c]}"
done
echo "TOTAL: $total"
