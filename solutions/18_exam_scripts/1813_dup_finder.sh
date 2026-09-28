#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
SUMS=$(find "$DIR" -type f ! -empty -exec md5sum {} + | sort)
N=0
for h in $(echo "$SUMS" | cut -c1-32 | uniq -d); do
  echo "$SUMS" | grep "^$h" | cut -c35- | sort | paste -sd'|'
done | sort | while IFS='|' read -ra g; do
  printf '%s\n' "${g[@]}"
  echo
done
N=$(echo "$SUMS" | cut -c1-32 | uniq -d | grep -c .)
echo "$N groups of duplicates"

