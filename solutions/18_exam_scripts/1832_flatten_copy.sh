#!/bin/bash
# flatten_copy.sh SRC DEST
usage() { echo "Usage: $(basename "$0") SRC DEST" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
SRC=$1
DEST=$2
[ -e "$SRC" ] || { echo "Error: '$SRC' does not exist" >&2; exit 2; }
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 3; }
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
  echo "Error: '$DEST' is not a directory" >&2
  exit 4
fi
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST" || exit 5
  echo "Directory $DEST created"
fi
N=0; M=0
while IFS= read -r -d '' f; do
  name=$(basename "$f")
  if [ -e "$DEST/$name" ]; then
    echo "skip: $name (from $f)" >&2
    M=$((M + 1))
  else
    cp "$f" "$DEST/$name" && { echo "copied: $f"; N=$((N + 1)); }
  fi
done < <(find "$SRC" -type f -print0 | sort -z)
echo "Copied $N files, skipped $M collisions"

