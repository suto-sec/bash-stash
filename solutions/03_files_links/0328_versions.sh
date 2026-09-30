#!/bin/bash
# versions.sh FILE [DIR] - keep numbered versions of a file
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $(basename "$0") FILE [DIR]" >&2
  exit 1
fi
FILE=$1
DIR=${2:-$HOME/versions}
[ -f "$FILE" ] || { echo "Error: '$FILE' is not a regular file" >&2; exit 2; }
if [ -e "$DIR" ] && [ ! -d "$DIR" ]; then
  echo "Error: '$DIR' is not a directory" >&2; exit 3
fi
if [ ! -d "$DIR" ]; then
  mkdir -p "$DIR" || exit 4
  echo "Created $DIR"
fi

name=$(basename "$FILE")
last=0 count=0
for v in "$DIR/$name".v*; do
  num=${v##*.v}
  [[ $num =~ ^[0-9]+$ ]] || continue       # skips .vold, .v3.bak and an unmatched glob
  count=$((count + 1))
  (( num > last )) && last=$num
done

if [ $last -gt 0 ] && cmp -s "$FILE" "$DIR/$name.v$last"; then
  echo "No changes since v$last"
else
  cp -p "$FILE" "$DIR/$name.v$((last + 1))"
  echo "Saved $FILE as $DIR/$name.v$((last + 1))"
  count=$((count + 1))
fi
echo "$count versions of $name"

