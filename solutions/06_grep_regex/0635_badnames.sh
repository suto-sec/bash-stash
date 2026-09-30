#!/bin/bash
# badnames.sh [DIR]
if [ $# -gt 1 ]; then
  echo "Usage: $(basename "$0") [DIR]" >&2
  exit 1
fi
DIR=${1:-.}
if [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2
  exit 2
fi

T=0 B=0
while IFS= read -r p; do
  T=$((T + 1))
  n=$(basename -- "$p")
  grep -qE '^[A-Za-z0-9._][A-Za-z0-9._-]*$' <<< "$n" && continue
  B=$((B + 1))
  if grep -q ' ' <<< "$n"; then k=space
  elif grep -q '^-' <<< "$n"; then k=dash
  else k=chars
  fi
  echo "$p ($k)"
done < <(find "$DIR" -mindepth 1 | sort)
echo "$B of $T names are not portable"
[ $B -eq 0 ] || exit 3

