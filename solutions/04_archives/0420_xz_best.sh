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
TOTAL_SAVED=0
while IFS= read -r f; do
  ORIG=$(stat -c%s "$f")
  gzip -9 -k "$f"
  cp "$f" "$f.xzcand"
  xz -9 "$f.xzcand"
  GZ_SZ=$(stat -c%s "$f.gz")
  XZ_SZ=$(stat -c%s "$f.xzcand.xz")
  if [ "$XZ_SZ" -lt "$GZ_SZ" ]; then
    rm -f "$f.gz"
    mv "$f.xzcand.xz" "$f.xz"
    KEPT=xz
    SZ=$XZ_SZ
  else
    rm -f "$f.xzcand.xz"
    KEPT=gz
    SZ=$GZ_SZ
  fi
  rm -f "$f"
  PCT=$(( (ORIG - SZ) * 100 / ORIG ))
  echo "$(basename "$f"): kept $KEPT ($SZ bytes, saved $PCT%)"
  TOTAL_N=$((TOTAL_N + 1))
  TOTAL_SAVED=$((TOTAL_SAVED + ORIG - SZ))
done < <(find "$DIR" -maxdepth 1 -type f | sort)
echo "Total: $TOTAL_N files, $TOTAL_SAVED bytes saved"

