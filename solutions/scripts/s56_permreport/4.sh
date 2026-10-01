#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
w=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  mode=$(stat -c %a "$f")
  if (( ${mode: -1} & 2 )); then echo "$mode $(basename "$f") !"; w=$((w + 1)); else echo "$mode $(basename "$f")"; fi
done
echo "World-writable: $w"
(( w == 0 )) || exit 4
