#!/bin/bash
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
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
