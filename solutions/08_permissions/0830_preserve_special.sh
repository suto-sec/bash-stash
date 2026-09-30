#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") FILE MODE" >&2
  exit 1
fi
FILE=$1
MODE=$2
[ -f "$FILE" ] || { echo "Error: '$FILE' is not a regular file" >&2; exit 2; }
[[ $MODE =~ ^[0-7]{3}$ ]] || { echo "Error: '$MODE' is not exactly 3 octal digits" >&2; exit 3; }

OLD=$(stat -c %a "$FILE")
if [ ${#OLD} -eq 4 ]; then
  special=${OLD:0:1}
  new="$special$MODE"
else
  new=$MODE
fi
chmod "$new" "$FILE"
NEW=$(stat -c %a "$FILE")
echo "$OLD -> $NEW"

