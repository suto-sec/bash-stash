#!/bin/bash
declare -A n
while IFS= read -r line; do
  h=${line:0:2}
  [[ -n $h ]] && n[$h]=$(( ${n[$h]:-0} + 1 ))
done < "$1"
best= max=0
for h in $(printf '%s\n' "${!n[@]}" | sort); do
  echo "$h: ${n[$h]}"
  if (( ${n[$h]} > max )); then max=${n[$h]}; best=$h; fi
done
echo "Busiest: ${best:-none}"
