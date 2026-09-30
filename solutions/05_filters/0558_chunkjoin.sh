#!/bin/bash
# chunkjoin.sh FILE K: group every K lines into one comma-joined line

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE K" >&2
  exit 1
fi
F=$1 K=$2
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if ! [[ $K =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$K' is not a positive integer" >&2
  exit 3
fi
LINES=$(wc -l < "$F")
if [ $((LINES % K)) -ne 0 ]; then
  echo "Error: '$F' has $LINES lines, not a multiple of $K" >&2
  exit 4
fi

DASHES=()
for i in $(seq "$K"); do DASHES+=(-); done
paste -d, "${DASHES[@]}" < "$F"
