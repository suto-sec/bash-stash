#!/bin/bash
# wc_totals.sh DIR EXT
usage() { echo "Usage: $(basename "$0") DIR EXT" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
DIR=$1
EXT=$2
[ -e "$DIR" ] || { echo "Error: '$DIR' does not exist" >&2; exit 2; }
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }
TF=0; TL=0; TW=0; TC=0
while IFS= read -r -d '' f; do
  read -r l w c _ <<< "$(wc -l -w -c < "$f")"
  echo "$f: $l lines, $w words, $c bytes"
  TF=$((TF + 1)); TL=$((TL + l)); TW=$((TW + w)); TC=$((TC + c))
done < <(find "$DIR" -type f -name "*.$EXT" -print0 | sort -z)
echo "TOTAL: $TF files, $TL lines, $TW words, $TC bytes"

