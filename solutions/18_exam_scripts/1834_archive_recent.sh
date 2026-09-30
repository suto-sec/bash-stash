#!/bin/bash
# archive_recent.sh DIR DAYS DEST
usage() { echo "Usage: $(basename "$0") DIR DAYS DEST" >&2; }
[ $# -eq 3 ] || { usage; exit 1; }
DIR=$1
DAYS=$2
DEST=$3
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
[[ $DAYS =~ ^[0-9]+$ ]] || { echo "Error: '$DAYS' is not a non-negative integer" >&2; exit 4; }
N=$(find "$DIR" -type f -mtime -"$DAYS" | wc -l)
[ "$N" -gt 0 ] || { echo "Error: no files modified in the last $DAYS days under $DIR" >&2; exit 5; }
if [ ! -d "$DEST" ]; then mkdir -p "$DEST" || exit 6; echo "Created $DEST"; fi
ABS=$(cd "$DEST" && pwd)/recent.tar.gz
( cd "$DIR" && find . -type f -mtime -"$DAYS" -print0 | tar -czf "$ABS" --null -T - )
echo "Archived $N files into $DEST/recent.tar.gz"

