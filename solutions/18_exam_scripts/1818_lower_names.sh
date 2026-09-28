#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
N=0
for p in "$DIR"/*; do
  name=$(basename "$p")
  lower=${name,,}
  [ "$name" = "$lower" ] && continue
  if [ -e "$DIR/$lower" ]; then
    echo "skip $name: $lower exists" >&2
    continue
  fi
  mv "$p" "$DIR/$lower"
  echo "$name -> $lower"
  N=$((N + 1))
done
echo "Renamed $N entries"

