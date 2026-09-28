#!/bin/bash
[ $# -le 2 ] || { echo "Usage: $(basename "$0") [DIR] [DAYS]" >&2; exit 1; }
DIR=${1:-.}
DAYS=${2:-7}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 2; }
[[ $DAYS =~ ^[0-9]+$ ]] || { echo "Error: DAYS must be a non-negative integer" >&2; exit 3; }
N=0
while IFS= read -r f; do
  rm -f "$f" && echo "Deleted $f" && N=$((N + 1))
done < <(find "$DIR" -type f \( -name '*.tmp' -o -name '*~' \) -mtime +"$DAYS" | sort)
echo "Deleted $N files"

