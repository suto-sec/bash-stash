#!/bin/bash
declare -A n
while read -r -a w; do
  [[ ${w[5]} == Accepted ]] && n[${w[8]}]=$(( ${n[${w[8]}]:-0} + 1 ))
done < "$1"
for u in $(printf '%s\n' "${!n[@]}" | sort); do echo "$u: ${n[$u]}"; done
echo "Accepted: $(grep -c 'Accepted password' "$1")"
echo "Failed: $(grep -c 'Failed password' "$1")"
