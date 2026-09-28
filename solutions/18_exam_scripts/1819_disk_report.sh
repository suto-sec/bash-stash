#!/bin/bash
DIR=${1:-.}
N=${2:-3}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
[[ $N =~ ^[0-9]+$ ]] && [ "$N" -gt 0 ] || { echo "Error: N must be a positive integer" >&2; exit 2; }
TOTAL=$(du -sk "$DIR" | cut -f1)
for d in "$DIR"/*/; do
  kb=$(du -sk "$d" | cut -f1)
  echo "$kb $(basename "$d")"
done | sort -k1,1nr -k2 | head -n "$N" | while read -r kb name; do
  echo "$kb KB $((kb * 100 / TOTAL))% $name"
done
echo "Total: $TOTAL KB"

