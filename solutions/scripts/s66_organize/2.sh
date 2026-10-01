#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  [[ $name == *.* ]] || continue
  ext=${name##*.}
  if [[ ! -d $1/$ext ]]; then mkdir -p "$1/$ext"; echo "Directory $1/$ext created"; fi
  mv -- "$f" "$1/$ext/"
done
exit 0
