#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
total=0 lines=
for d in "$1"/*/; do
  [[ -d $d ]] || continue
  d=${d%/}
  s=$(du -sb "$d" | cut -f1)
  lines+="$(basename "$d"): $s"$'\n'
  total=$((total + s))
done
[[ -n $lines ]] && printf '%s' "$lines" | sort -t: -k2,2nr -k1,1
echo "Total: $total"
