#!/bin/bash
# vaciar.sh DIR - delete empty files, then empty (or emptied) directories
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

F=0
while IFS= read -r f; do
  rm -f "$f" && echo "removed file $f" && F=$((F + 1))
done < <(find "$DIR" -type f -empty | sort)

D=0
while IFS= read -r d; do
  echo "removed dir $d"
  D=$((D + 1))
done < <(find "$DIR" -mindepth 1 -type d -empty -delete -print | sort -r)

echo "Removed $F empty files and $D empty directories"

