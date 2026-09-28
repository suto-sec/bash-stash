#!/bin/bash
DIR=${1:-.}
[ -d "$DIR" ] || { echo "Error: $DIR is not a directory" >&2; exit 1; }
F=0; TL=0; TE=0; TW=0; RC=0
while IFS= read -r f; do
  if [ ! -r "$f" ]; then echo "cannot read $f" >&2; RC=4; continue; fi
  l=$(wc -l < "$f"); e=$(grep -ci error "$f"); w=$(grep -ci warn "$f")
  echo "$f: $l lines, $e errors, $w warnings"
  F=$((F + 1)); TL=$((TL + l)); TE=$((TE + e)); TW=$((TW + w))
done < <(find "$DIR" -type f -name '*.log' | sort)
echo "TOTAL: $F files, $TL lines, $TE errors, $TW warnings"
exit $RC
