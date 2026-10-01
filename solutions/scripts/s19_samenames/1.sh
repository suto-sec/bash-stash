#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  [[ -f $2/$name ]] && echo "$name"
done
exit 0
