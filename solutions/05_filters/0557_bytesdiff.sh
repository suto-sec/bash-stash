#!/bin/bash
# bytesdiff.sh FILE1 FILE2: reports byte differences between two files

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE1 FILE2" >&2
  exit 1
fi
A=$1 B=$2
for f in "$A" "$B"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: cannot read '$f'" >&2
    exit 2
  fi
done
SA=$(wc -c < "$A") SB=$(wc -c < "$B")
if [ "$SA" -ne "$SB" ]; then
  echo "Error: '$A' and '$B' have different sizes" >&2
  exit 3
fi

D=$(cmp -l -- "$A" "$B")
if [ -z "$D" ]; then
  echo "Identical"
  exit 0
fi
echo "$D"
echo "Total: $(echo "$D" | wc -l) bytes differ"
exit 4

