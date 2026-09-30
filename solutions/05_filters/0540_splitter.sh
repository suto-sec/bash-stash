#!/bin/bash
# splitter.sh FILE LINES [PREFIX]

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE LINES [PREFIX]" >&2
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

if [ $# -eq 3 ]; then
  P=$3
else
  P=$(basename "$F")
  P="${P%.*}_"
fi

for f in "$P"[0-9][0-9][0-9]; do
  if [ -e "$f" ]; then
    echo "Error: '$f' already exists" >&2
    exit 4
  fi
done

split -l "$N" -d -a 3 "$F" "$P"

K=0
for f in "$P"[0-9][0-9][0-9]; do
  [ -e "$f" ] || continue          # no pieces: the pattern stays unexpanded
  echo "$f: $(wc -l < "$f") lines, $(wc -c < "$f") bytes"
  K=$((K + 1))
done
echo "Total: $(wc -l < "$F") lines in $K pieces"

