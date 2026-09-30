#!/bin/bash
# textstats.sh FILE...: wc report sorted by number of words

if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi

F=0 TL=0 TW=0 TB=0 BAD=0 ROWS=
for f in "$@"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: cannot read '$f'" >&2
    BAD=1
    continue
  fi
  l=$(wc -l < "$f") w=$(wc -w < "$f") b=$(wc -c < "$f") x=$(wc -L < "$f")
  # words <TAB> name <TAB> the line to print
  ROWS+="$w"$'\t'"$f"$'\t'"$f: $l lines, $w words, $b bytes, longest $x"$'\n'
  F=$((F + 1)) TL=$((TL + l)) TW=$((TW + w)) TB=$((TB + b))
done

printf '%s' "$ROWS" | sort -t$'\t' -k1,1nr -k2,2 | cut -f3-
echo "TOTAL: $F files, $TL lines, $TW words, $TB bytes"
[ $BAD -eq 1 ] && exit 2
exit 0

