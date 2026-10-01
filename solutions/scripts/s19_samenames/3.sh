#!/bin/bash
if (( $# != 2 )); then echo "Error: two directories are needed" >&2; echo "Usage: $0 dir1 dir2" >&2; exit 1; fi
for d in "$1" "$2"; do
  [[ -e $d ]] || { echo "Error: $d does not exist" >&2; exit 2; }
  [[ -d $d ]] || { echo "Error: $d is not a directory" >&2; exit 3; }
done
n=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ -f $2/$name ]]; then echo "$name"; n=$((n + 1)); fi
done
echo "Common: $n"
