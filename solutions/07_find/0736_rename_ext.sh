#!/bin/bash
# cambiaext.sh DIR OLD NEW - rename *.OLD to *.NEW recursively
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") DIR OLD NEW" >&2
  exit 1
fi
DIR=$1
OLD=$2
NEW=$3
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
if [ -z "$OLD" ] || [ -z "$NEW" ] || [ "$OLD" = "$NEW" ]; then
  echo "Error: OLD and NEW must be non-empty and different" >&2
  exit 3
fi

N=0
S=0
while IFS= read -r f; do
  new="${f%."$OLD"}.$NEW"
  if [ -e "$new" ]; then
    echo "skip $f: $new exists" >&2
    S=$((S + 1))
    continue
  fi
  mv "$f" "$new" && echo "renamed $f -> $new" && N=$((N + 1))
done < <(find "$DIR" -type f -name "*.$OLD" | sort)
echo "Renamed $N files, skipped $S"
[ $S -eq 0 ] || exit 4

