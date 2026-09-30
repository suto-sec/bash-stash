#!/bin/bash
# materialize.sh DIR - replace symbolic links by copies of their targets
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") DIR" >&2; exit 1; }
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

n=0 broken=0
for l in "$DIR"/*; do
  [ -L "$l" ] || continue
  name=$(basename "$l")
  if [ ! -e "$l" ]; then
    echo "broken: $name" >&2
    broken=$((broken + 1))
    continue
  fi
  target=$(readlink -f "$l")      # resolve before removing the link (relative targets!)
  rm "$l"
  if [ -d "$target" ]; then
    cp -r "$target" "$l"; echo "$name: dir"
  else
    cp "$target" "$l"; echo "$name: file"
  fi
  n=$((n + 1))
done
echo "Replaced $n links, $broken broken"
[ $broken -eq 0 ] || exit 3

