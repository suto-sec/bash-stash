#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") SRCDIR EXT OUTFILE" >&2
  exit 1
fi
SRC=$1
EXT=$2
OUT=$3
if [ ! -e "$SRC" ]; then
  echo "Error: $SRC does not exist" >&2
  exit 2
fi
if [ ! -d "$SRC" ]; then
  echo "Error: $SRC is not a directory" >&2
  exit 3
fi

FILES=()
while IFS= read -r f; do FILES+=("$f"); done < <(cd "$SRC" && find . -type f -name "*.$EXT" | sed 's#^\./##' | sort)

if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: no .$EXT files found under $SRC" >&2
  exit 4
fi

TOTAL=0
for f in "${FILES[@]}"; do
  SZ=$(stat -c%s "$SRC/$f")
  TOTAL=$((TOTAL + SZ))
done

tar -cJf "$OUT" -C "$SRC" "${FILES[@]}"
echo "Packed ${#FILES[@]} files ($TOTAL bytes) into $OUT"

