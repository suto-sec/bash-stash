#!/bin/bash
# safe_delete.sh REF FILE...
if [ $# -lt 2 ]; then
  echo "usage: $(basename "$0") REF FILE..." >&2
  exit 1
fi
REF=$1
shift
if [ ! -e "$REF" ]; then
  echo "error: '$REF' does not exist" >&2
  exit 2
fi
R=0
N=0
for f in "$@"; do
  N=$((N + 1))
  if [ -f "$f" ] && [ -w "$f" ] && [ ! -x "$f" ] && [ "$f" -ot "$REF" ]; then
    rm -- "$f"
    echo "borrado: $f"
    R=$((R + 1))
  else
    echo "omitido: $f"
  fi
done
echo "TOTAL: $R borrados de $N candidatos"

