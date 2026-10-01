#!/bin/bash
declare -A n
while read -r -a w; do
  [[ " ${w[*]} " == *" CMD "* ]] || continue
  u=${w[5]#(}; u=${u%)}
  n[$u]=$(( ${n[$u]:-0} + 1 ))
done < "$1"
for u in $(printf '%s\n' "${!n[@]}" | sort); do echo "$u: ${n[$u]}"; done
echo "Jobs: $(grep -c ' CMD (' "$1")"
