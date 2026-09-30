#!/bin/bash
# splitcount.sh FILE N: line/word counts of FILE split into chunks of N lines

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE N" >&2
  exit 1
fi
F=$1 N=$2
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if ! [[ $N =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$N' is not a positive integer" >&2
  exit 3
fi

TMP=$(mktemp -d)
split -l "$N" -- "$F" "$TMP/part_"

i=0
for p in "$TMP"/part_*; do
  i=$((i + 1))
  echo "chunk $i: $(wc -l < "$p") lines, $(wc -w < "$p") words"
done
echo "Total: $i chunks"
rm -rf "$TMP"

