#!/bin/bash
# dirsizes.sh DIR - files and bytes of every first-level subdirectory of DIR

if [ $# -ne 1 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=$1
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

LINES=$(
  find "$DIR" -mindepth 1 -maxdepth 1 -type d -print0 |
  while IFS= read -r -d '' d; do
    files=$(find "$d" -type f | wc -l)
    bytes=$(find "$d" -type f -print0 | xargs -0 -r cat | wc -c)
    echo "$bytes $files ${d##*/}"
  done | sort -k1,1nr -k3
)
[ -n "$LINES" ] || { echo "Error: '$DIR' has no subdirectories" >&2; exit 4; }

echo "$LINES"
ND=0 NF=0 NB=0
while read -r b f _; do
  ND=$((ND + 1)); NF=$((NF + f)); NB=$((NB + b))
done <<< "$LINES"
echo "Total: $NF files, $NB bytes in $ND directories"

