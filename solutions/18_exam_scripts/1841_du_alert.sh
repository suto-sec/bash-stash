#!/bin/bash
# du_alert.sh DIR LIMIT_KB
usage() { echo "Usage: $(basename "$0") DIR LIMIT_KB" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
DIR=$1
LIMIT=$2
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
[[ $LIMIT =~ ^[0-9]+$ ]] && [ "$LIMIT" -gt 0 ] || { echo "Error: '$LIMIT' is not a positive integer" >&2; exit 4; }
BYTES=$((LIMIT * 1024))
find "$DIR" -type f -size +"${BYTES}"c -printf '%s %p\n' | sort -k1,1nr -k2 | while read -r sz name; do echo "$sz bytes $name"; done
N=0; SUM=0
while IFS= read -r sz; do N=$((N + 1)); SUM=$((SUM + sz)); done < <(find "$DIR" -type f -size +"${BYTES}"c -printf '%s\n')
echo "Total: $N files over $LIMIT KB ($SUM bytes)"

