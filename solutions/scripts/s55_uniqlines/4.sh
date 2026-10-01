#!/bin/bash
count=
if [[ $1 == -c ]]; then count=1; shift; fi
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 [-c] file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
if [[ -n $count ]]; then
  declare -A n
  while IFS= read -r l; do n[$l]=$(( ${n[$l]:-0} + 1 )); done < "$1"
  for l in "${!n[@]}"; do echo "${n[$l]} $l"; done | sort -k1,1nr -k2
else
  sort -u "$1"
fi
echo "Distinct: $(sort -u "$1" | wc -l)"
