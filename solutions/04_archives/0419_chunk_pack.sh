#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") FILE SIZE" >&2
  exit 1
fi
FILE=$1
SIZE=$2
if [ ! -e "$FILE" ]; then
  echo "Error: $FILE does not exist" >&2
  exit 2
fi
if [ ! -f "$FILE" ]; then
  echo "Error: $FILE is not a regular file" >&2
  exit 3
fi
if ! [[ $SIZE =~ ^[0-9]+$ ]] || [ "$SIZE" -le 0 ]; then
  echo "Error: SIZE must be a positive integer, got '$SIZE'" >&2
  exit 4
fi

DEST="$FILE.chunks"
mkdir -p "$DEST"
split -b "$SIZE" -d "$FILE" "$DEST/part_"

TOTAL=0
N=0
for c in "$DEST"/part_*; do
  SZ=$(stat -c%s "$c")
  gzip "$c"
  echo "$(basename "$c").gz: $SZ bytes"
  TOTAL=$((TOTAL + SZ))
  N=$((N + 1))
done
echo "Total: $N chunks, $TOTAL bytes original"

