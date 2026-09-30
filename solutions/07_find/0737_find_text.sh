#!/bin/bash
# buscatexto.sh WORD DIR [EXT] - count lines with WORD (whole word, any case) per file
if [ $# -lt 2 ] || [ $# -gt 3 ] || [ -z "$1" ]; then
  echo "Usage: $(basename "$0") WORD DIR [EXT]" >&2
  exit 2
fi
WORD=$1
DIR=$2
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
PAT='*'
[ -n "$3" ] && PAT="*.$3"

R=$(find "$DIR" -type f -name "$PAT" -readable | while IFS= read -r f; do
      c=$(grep -ciw -- "$WORD" "$f")
      [ "$c" -gt 0 ] && echo "$c $f"
    done | sort -k1,1nr -k2)

L=0
N=0
if [ -n "$R" ]; then
  echo "$R"
  while read -r c f; do
    L=$((L + c))
    N=$((N + 1))
  done <<< "$R"
fi
echo "$WORD: $L lines in $N files"
[ $N -gt 0 ] || exit 1

