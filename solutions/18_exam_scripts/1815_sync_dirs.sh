#!/bin/bash
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") SRC DST" >&2; exit 1; }
SRC=$1
DST=$2
[ -d "$SRC" ] || { echo "Error: $SRC is not a directory" >&2; exit 2; }
if [ ! -d "$DST" ]; then mkdir -p "$DST" || exit 3; echo "Created $DST"; fi
N=0
while IFS= read -r -d '' f; do
  rel=${f#"$SRC"/}
  if [ ! -e "$DST/$rel" ] || [ "$f" -nt "$DST/$rel" ]; then
    mkdir -p "$DST/$(dirname "$rel")"
    cp -p "$f" "$DST/$rel" && echo "copied: $rel" && N=$((N + 1))
  fi
done < <(find "$SRC" -type f -print0 | sort -z)
echo "$N files copied"

