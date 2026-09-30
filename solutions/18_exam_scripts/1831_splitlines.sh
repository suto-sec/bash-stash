#!/bin/bash
# splitlines.sh FILE N
usage() { echo "Usage: $(basename "$0") FILE N" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
FILE=$1
N=$2
[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 2; }
[[ $N =~ ^[0-9]+$ ]] && [ "$N" -gt 0 ] || { echo "Error: '$N' is not a positive integer" >&2; exit 3; }
split -l "$N" -d -a 2 "$FILE" "$FILE.part"
K=$(ls -1 "$FILE".part?? 2>/dev/null | wc -l)
echo "Created $K parts"

