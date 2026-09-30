#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") FILE N" >&2
  exit 1
fi
FILE=$1
N=$2
if [ ! -f "$FILE" ]; then
  echo "Error: '$FILE' is not a regular file" >&2
  exit 2
fi
if ! [[ $N =~ ^[0-9]+$ ]] || [ "$N" -le 0 ]; then
  echo "Error: N must be a positive integer, got '$N'" >&2
  exit 3
fi

for ((k = N - 1; k >= 1; k--)); do
  if [ -e "$FILE.$k" ]; then
    mv -f "$FILE.$k" "$FILE.$((k + 1))"
    echo "$FILE.$k -> $FILE.$((k + 1))"
  fi
done

cp -p "$FILE" "$FILE.1"
echo "Saved $FILE as $FILE.1"

count=0
for ((k = 1; k <= N; k++)); do
  [ -e "$FILE.$k" ] && count=$((count + 1))
done
echo "$count backups now"

