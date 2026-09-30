#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") SRC DST" >&2
  exit 1
fi
SRC=$1
DST=$2
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 2; }
if [ -e "$DST" ] && [ ! -d "$DST" ]; then
  echo "Error: '$DST' is not a directory" >&2
  exit 3
fi
mkdir -p "$DST"

copied=0
total=0
while IFS= read -r f; do
  total=$((total + 1))
  rel=${f#"$SRC"/}
  if [ ! -e "$DST/$rel" ] || [ "$(stat -c %Y "$DST/$rel")" -lt "$(stat -c %Y "$f")" ]; then
    mkdir -p "$DST/$(dirname "$rel")"
    cp -p "$f" "$DST/$rel"
    echo "$rel"
    copied=$((copied + 1))
  fi
done < <(find "$SRC" -type f | sort)
echo "Copied $copied of $total files"

