#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 dir [bytes]" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
limit=${2:-100}
[[ $limit =~ ^[0-9]+$ ]] || { echo "Error: '$limit' is not a number" >&2; exit 4; }
for f in "$1"/*; do
  [[ -f $f ]] || continue
  size=$(stat -c %s "$f")
  (( size > limit )) && echo "$(basename "$f"): $size"
done
exit 0
