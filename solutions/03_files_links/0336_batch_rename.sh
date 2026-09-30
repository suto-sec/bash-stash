#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") DIR OLDEXT NEWEXT" >&2
  exit 1
fi
DIR=$1
OLDEXT=$2
NEWEXT=$3
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
if [ -z "$OLDEXT" ] || [ -z "$NEWEXT" ] || [[ $OLDEXT == */* ]] || [[ $NEWEXT == */* ]]; then
  echo "Error: OLDEXT and NEWEXT must be non-empty and contain no '/'" >&2
  exit 3
fi

renamed=0
total=0
skipped=0
while IFS= read -r f; do
  total=$((total + 1))
  new=${f%."$OLDEXT"}.$NEWEXT
  if [ -e "$new" ]; then
    echo "skip $f ($new already exists)" >&2
    skipped=$((skipped + 1))
  else
    mv "$f" "$new"
    echo "$f -> $new"
    renamed=$((renamed + 1))
  fi
done < <(find "$DIR" -type f -name "*.$OLDEXT" | sort)
echo "Renamed $renamed of $total"
[ $skipped -eq 0 ] || exit 4
