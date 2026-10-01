#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  [[ $name == *.* ]] || continue
  ext=${name##*.}
  mkdir -p "$1/$ext"
  mv -- "$f" "$1/$ext/"
done
exit 0
