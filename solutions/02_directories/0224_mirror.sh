#!/bin/bash
# mirror.sh SRC DEST - recreates the directory structure of SRC in DEST
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") SRC DEST" >&2
  exit 1
fi
SRC=$1 DEST=$2
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 2; }
PARENT=$(dirname "$DEST")
if [ -e "$DEST" ] || [ ! -d "$PARENT" ]; then
  echo "Error: '$DEST' already exists or its parent directory does not exist" >&2
  exit 3
fi
SRC_ABS=$(cd "$SRC" && pwd -P)
PARENT_ABS=$(cd "$PARENT" && pwd -P)
if [[ $PARENT_ABS == "$SRC_ABS" || $PARENT_ABS == "$SRC_ABS"/* ]]; then
  echo "Error: '$DEST' is inside '$SRC'" >&2
  exit 4
fi

mkdir "$DEST"
DEST_ABS=$(cd "$DEST" && pwd -P)
N=0
while IFS= read -r d; do
  mkdir -p "$DEST_ABS/$d"
  N=$((N + 1))
done < <(cd "$SRC" && find . -mindepth 1 -type d)
echo "Mirrored $N directories from $SRC into $DEST"

