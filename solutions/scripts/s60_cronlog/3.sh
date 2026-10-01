#!/bin/bash
if (( $# != 1 )); then echo "Error: one log is needed" >&2; echo "Usage: $0 log" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
declare -A n
while read -r -a w; do
  [[ " ${w[*]} " == *" CMD "* ]] || continue
  u=${w[5]#(}; u=${u%)}
  n[$u]=$(( ${n[$u]:-0} + 1 ))
done < "$1"
for u in $(printf '%s\n' "${!n[@]}" | sort); do echo "$u: ${n[$u]}"; done
echo "Jobs: $(grep -c ' CMD (' "$1")"
