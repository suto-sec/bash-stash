#!/bin/bash
# fix_broken_links.sh DIR
usage() { echo "Usage: $(basename "$0") DIR" >&2; }
[ $# -eq 1 ] || { usage; exit 1; }
DIR=$1
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
N=0
while IFS= read -r -d '' f; do
  echo "broken: $f -> $(readlink "$f")"
  rm "$f" && N=$((N + 1))
done < <(find "$DIR" -xtype l -print0 | sort -z)
echo "Removed $N broken links"

