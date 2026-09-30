#!/bin/bash
# verify_backup.sh SRC DEST
usage() { echo "Usage: $(basename "$0") SRC DEST" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
SRC=$1
DEST=$2
[ -e "$SRC" ] || { echo "Error: '$SRC' does not exist" >&2; exit 2; }
[ -d "$SRC" ] || { echo "Error: '$SRC' is not a directory" >&2; exit 3; }
[ -e "$DEST" ] || { echo "Error: '$DEST' does not exist" >&2; exit 4; }
[ -d "$DEST" ] || { echo "Error: '$DEST' is not a directory" >&2; exit 5; }
OK=0; DIF=0; MISS=0; N=0
while IFS= read -r -d '' f; do
  rel=${f#"$SRC"/}
  N=$((N + 1))
  if [ ! -e "$DEST/$rel" ]; then
    echo "MISSING $rel"; MISS=$((MISS + 1))
  elif [ -f "$DEST/$rel" ] && cmp -s "$f" "$DEST/$rel"; then
    echo "OK $rel"; OK=$((OK + 1))
  else
    echo "DIFF $rel"; DIF=$((DIF + 1))
  fi
done < <(find "$SRC" -type f -print0 | sort -z)
echo "SRC has $N files: $OK ok, $DIF differing, $MISS missing"

