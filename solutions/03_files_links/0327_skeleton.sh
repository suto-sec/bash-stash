#!/bin/bash
# skeleton.sh SRC DST - copy the directory structure of SRC with empty files
[ $# -eq 2 ] || { echo "Usage: $(basename "$0") SRC DST" >&2; exit 1; }
SRC=$1 DST=$2
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 2; }
[ -e "$DST" ] && { echo "Error: '$DST' already exists" >&2; exit 3; }

mkdir -p "$DST"
nd=0 nf=0
while IFS= read -r -d '' d; do
  mkdir -p "$DST/${d#"$SRC"/}"
  nd=$((nd + 1))
done < <(find "$SRC" -mindepth 1 -type d -print0)
while IFS= read -r -d '' f; do
  touch -r "$f" "$DST/${f#"$SRC"/}"
  nf=$((nf + 1))
done < <(find "$SRC" -type f -print0)
echo "$nd directories, $nf files"

