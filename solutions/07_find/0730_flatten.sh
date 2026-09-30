#!/bin/bash
# flatten.sh SRC DEST EXT - copy every *.EXT under SRC into DEST, renaming collisions
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") SRC DEST EXT" >&2
  exit 1
fi
SRC=$1
DEST=$2
EXT=$3
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 2; }
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
  echo "Error: '$DEST' exists and is not a directory" >&2
  exit 3
fi
[[ $EXT =~ ^[[:alnum:]]+$ ]] || { echo "Error: invalid extension '$EXT'" >&2; exit 4; }

if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST"
  echo "Created $DEST"
fi

N=0
while IFS= read -r f; do
  name=$(basename "$f")
  base=${name%."$EXT"}
  target=$name
  k=2
  while [ -e "$DEST/$target" ]; do
    target="${base}_$k.$EXT"
    k=$((k + 1))
  done
  cp "$f" "$DEST/$target" && echo "$f -> $target" && N=$((N + 1))
done < <(find "$SRC" -type f -name "*.$EXT" | sort)
echo "Copied $N files"

