#!/bin/bash
[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Usage: $(basename "$0") ARCHIVE.tgz [KB]" >&2; exit 1; }
ARCH=$1
KB=${2:-8}
[ -f "$ARCH" ] && tar -tzf "$ARCH" > /dev/null 2>&1 || { echo "Error: $ARCH is not a valid .tgz" >&2; exit 2; }
[[ $KB =~ ^[0-9]+$ ]] && [ "$KB" -gt 0 ] || { echo "Error: KB must be a positive integer" >&2; exit 3; }

TMP=$(mktemp -d)
tar -xzf "$ARCH" -C "$TMP"
M=0
while IFS= read -r f; do
  echo "Removed ${f#./} ($(stat -c %s "$TMP/$f") bytes)"
  rm "$TMP/$f"
  M=$((M + 1))
done < <(cd "$TMP" && find . -type f -size +$((KB * 1024))c | sort)
K=$(find "$TMP" -type f | wc -l)
ABS=$(cd "$(dirname "$ARCH")" && pwd)/$(basename "$ARCH")
(cd "$TMP" && tar -czf "$ABS" $(ls -A))
rm -rf "$TMP"
echo "Kept $K files, removed $M files"

