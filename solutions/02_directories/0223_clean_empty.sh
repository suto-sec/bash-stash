#!/bin/bash
# cleanempty.sh DIR - removes the empty directories under DIR
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=${1%/}
[ -z "$DIR" ] && DIR=/
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

REMOVED=$(find "$DIR" -mindepth 1 -depth -type d | while IFS= read -r d; do
  rmdir "$d" 2> /dev/null && echo "removed $d"
done | sort)
[ -n "$REMOVED" ] && echo "$REMOVED"
N=$(echo -n "$REMOVED" | grep -c '^')
M=$(find "$DIR" -mindepth 1 -type d | wc -l)
echo "Removed $N directories, $M remain"

