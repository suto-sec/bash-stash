#!/bin/bash
# size_classes.sh directory min max - classify files by size

if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") directory min max" >&2
  exit 1
fi
dir=$1 min=$2 max=$3
if [ ! -d "$dir" ]; then
  echo "Error: '$dir' is not a directory" >&2
  exit 2
fi
for n in "$min" "$max"; do
  if [[ ! $n =~ ^[0-9]+$ ]]; then
    echo "Error: '$n' is not a non-negative integer" >&2
    exit 3
  fi
done
if [ "$min" -gt "$max" ]; then
  echo "Error: min ($min) is greater than max ($max)" >&2
  exit 4
fi

u=0 e=0 s=0 o=0 b=0
for f in "$dir"/*; do
  [ -f "$f" ] || continue
  size=$(stat -c %s "$f")
  if [ ! -r "$f" ]; then c=unreadable; u=$((u + 1))
  elif [ ! -s "$f" ]; then c=empty; e=$((e + 1))
  elif [ "$size" -lt "$min" ]; then c=small; s=$((s + 1))
  elif [ "$size" -gt "$max" ]; then c=big; b=$((b + 1))
  else c=ok; o=$((o + 1))
  fi
  echo "$(basename "$f"): $c ($size bytes)"
done
echo "Files: $((u + e + s + o + b)) (unreadable $u, empty $e, small $s, ok $o, big $b)"

