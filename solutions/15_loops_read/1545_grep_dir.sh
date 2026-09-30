#!/bin/bash
# grep_dir.sh DIR PATTERN
if [ $# -ne 2 ]; then
  echo "usage: $(basename "$0") DIR PATTERN" >&2
  exit 1
fi
D=$1; PAT=$2
[ -d "$D" ] || { echo "error: '$D' is not a directory" >&2; exit 2; }
[ -n "$PAT" ] || { echo "error: empty pattern" >&2; exit 3; }

T=0; M=0; F=0
while IFS= read -r -d '' f; do
  F=$((F + 1))
  n=$(grep -c -- "$PAT" "$f")
  if [ "$n" -gt 0 ]; then
    echo "$f: $n"
    T=$((T + n)); M=$((M + 1))
  fi
done < <(find "$D" -type f -print0 | sort -z)
echo "TOTAL: $T matches in $M files (of $F escaneados)"

