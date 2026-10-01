#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  size=$(stat -c %s "$f")
  (( size > 100 )) && echo "$(basename "$f"): $size"
done
exit 0
