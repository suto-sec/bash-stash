#!/bin/bash
if (( $# != 1 )); then echo "Error: one log is needed" >&2; echo "Usage: $0 log" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
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
