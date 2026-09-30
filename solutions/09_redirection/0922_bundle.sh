#!/bin/bash
# bundle.sh OUT FILE...
if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") OUT FILE..." >&2
  exit 1
fi
OUT=$1
shift
for f in "$@"; do
  if [ "$f" -ef "$OUT" ]; then
    echo "Error: '$f' is the output file" >&2
    exit 3
  fi
done
if ! : 2>/dev/null > "$OUT"; then
  echo "Error: cannot write '$OUT'" >&2
  exit 4
fi

RC=0 K=0
for f in "$@"; do
  if [ -f "$f" ] && [ -r "$f" ]; then
    { echo "==> $f <=="; cat "$f"; } >> "$OUT"
    echo "added $f ($(wc -l < "$f") lines)"
    K=$((K + 1))
  else
    echo "Error: cannot read '$f'" >&2
    RC=2
  fi
done
echo "$K files, $(wc -l < "$OUT") lines written to $OUT"
exit $RC

