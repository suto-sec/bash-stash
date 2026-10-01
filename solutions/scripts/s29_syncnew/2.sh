#!/bin/bash
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ ! -e $2/$name || $f -nt $2/$name ]]; then
    cp -- "$f" "$2/" 2>/dev/null && echo "copied $name"
  fi
done
exit 0
