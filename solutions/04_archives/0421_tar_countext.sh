#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") ARCHIVE" >&2
  exit 1
fi
ARCH=$1
if [ ! -e "$ARCH" ]; then
  echo "Error: $ARCH does not exist" >&2
  exit 2
fi
if ! tar -tf "$ARCH" >/dev/null 2>&1; then
  echo "Error: $ARCH is not a readable tar archive" >&2
  exit 3
fi

EXTLIST=$(
  while IFS= read -r p; do
    [[ $p == */ ]] && continue
    b=$(basename "$p")
    if [[ $b == *.* ]]; then echo ".${b##*.}"; else echo "(none)"; fi
  done < <(tar -tf "$ARCH")
)

TOTAL=0
while read -r cnt ext; do
  [ -z "$cnt" ] && continue
  echo "$ext: $cnt"
  TOTAL=$((TOTAL + cnt))
done < <(echo "$EXTLIST" | sort | uniq -c | sort -k2,2)

echo "Total: $TOTAL"
