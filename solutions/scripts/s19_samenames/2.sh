#!/bin/bash
n=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ -f $2/$name ]]; then echo "$name"; n=$((n + 1)); fi
done
echo "Common: $n"
