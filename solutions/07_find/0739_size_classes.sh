#!/bin/bash
# tallas.sh DIR... - regular files per size class
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") DIR..." >&2
  exit 1
fi

BAD=0
T=0
for d in "$@"; do
  if [ ! -d "$d" ]; then
    echo "Error: '$d' is not a directory" >&2
    BAD=1
    continue
  fi
  e=$(find "$d" -type f -empty | wc -l)
  s=$(find "$d" -type f -size +0c -size -1025c | wc -l)
  m=$(find "$d" -type f -size +1024c -size -1048577c | wc -l)
  l=$(find "$d" -type f -size +1048576c | wc -l)
  echo "$d: $e empty, $s small, $m medium, $l large"
  T=$((T + e + s + m + l))
done
echo "Total: $T files"
[ $BAD -eq 0 ] || exit 2
