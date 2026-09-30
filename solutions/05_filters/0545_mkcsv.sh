#!/bin/bash
# mkcsv.sh OUTPUT FILE1 FILE2 [FILE...]: one CSV column per input file

if [ $# -lt 3 ]; then
  echo "Error: at least an output and two input files are needed" >&2
  echo "Usage: $(basename "$0") OUTPUT FILE1 FILE2 [FILE...]" >&2
  exit 1
fi
OUT=$1
shift
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: cannot read '$f'" >&2
    exit 2
  fi
done
if [ -e "$OUT" ]; then
  echo "Error: '$OUT' already exists" >&2
  exit 3
fi

for f in "$@"; do
  b=$(basename "$f")
  echo "${b%.txt}"
done | paste -s -d, > "$OUT"
paste -d, "$@" >> "$OUT"

echo "$OUT: $# columns, $(( $(wc -l < "$OUT") - 1 )) rows"

