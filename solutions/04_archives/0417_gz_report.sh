#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") DIR" >&2
  exit 1
fi
DIR=$1
if [ ! -e "$DIR" ]; then
  echo "Error: $DIR does not exist" >&2
  exit 2
fi
if [ ! -d "$DIR" ]; then
  echo "Error: $DIR is not a directory" >&2
  exit 3
fi

TOTAL_N=0
TOTAL_B=0
while IFS= read -r f; do
  SZ=$(zcat "$f" | wc -c)
  echo "$(basename "$f"): $SZ bytes"
  TOTAL_N=$((TOTAL_N + 1))
  TOTAL_B=$((TOTAL_B + SZ))
done < <(find "$DIR" -maxdepth 1 -type f -name '*.gz' | sort)
echo "Total: $TOTAL_N files, $TOTAL_B bytes"

