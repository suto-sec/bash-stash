#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ $name == *.* ]]; then ext=${name##*.}; else ext=noext; fi
  if [[ ! -d $1/$ext ]]; then mkdir -p "$1/$ext"; echo "Directory $1/$ext created"; fi
  target=$name; k=0
  while [[ -e $1/$ext/$target ]]; do k=$((k + 1)); target=$name.$k; done
  [[ $target != "$name" ]] && echo "renamed $name to $target"
  mv -- "$f" "$1/$ext/$target"
done
exit 0
