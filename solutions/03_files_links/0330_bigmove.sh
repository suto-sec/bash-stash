#!/bin/bash
# bigmove.sh DIR SIZE DEST - move files bigger than SIZE bytes into DEST
[ $# -eq 3 ] || { echo "Usage: $(basename "$0") DIR SIZE DEST" >&2; exit 1; }
DIR=$1 SIZE=$2 DEST=$3
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[[ $SIZE =~ ^[0-9]+$ ]] || { echo "Error: '$SIZE' is not a valid size" >&2; exit 3; }
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then
  echo "Error: '$DEST' is not a directory" >&2; exit 4
fi
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST" || exit 5
  echo "Created $DEST"
fi

n=0 total=0
while IFS=$'\t' read -r size name; do
  if [ -e "$DEST/$name" ]; then
    echo "$name already exists in $DEST" >&2
    continue
  fi
  mv "$DIR/$name" "$DEST/"
  echo "$size $name"
  n=$((n + 1)); total=$((total + size))
done < <(
  for f in "$DIR"/*; do
    [ -f "$f" ] && [ ! -L "$f" ] || continue
    s=$(stat -c %s "$f")
    [ "$s" -gt "$SIZE" ] && printf '%s\t%s\n' "$s" "$(basename "$f")"
  done | sort -t $'\t' -k1,1nr -k2
)
echo "Moved $n files ($total bytes)"
