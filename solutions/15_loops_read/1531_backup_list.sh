#!/bin/bash
# backup_list.sh LIST DEST
[ $# -eq 2 ] || { echo "usage: $(basename "$0") LIST DEST" >&2; exit 1; }
LIST=$1; DEST=$2
[ -f "$LIST" ] && [ -r "$LIST" ] || { echo "error: cannot read list '$LIST'" >&2; exit 2; }
if [ -e "$DEST" ] && [ ! -d "$DEST" ]; then echo "error: '$DEST' is not a directory" >&2; exit 3; fi
if [ ! -d "$DEST" ]; then mkdir -p "$DEST" && echo "created $DEST"; fi

C=0; M=0; S=0
seen=$'\n'                               # base names copied so far, one per line
while IFS= read -r p; do
  [[ -z $p || $p == \#* ]] && continue
  if [ ! -e "$p" ]; then echo "missing: $p" >&2; M=$((M + 1)); continue; fi
  if [ ! -f "$p" ]; then echo "skipped $p (not a file)"; S=$((S + 1)); continue; fi
  b=$(basename "$p")
  if [[ $seen == *$'\n'"$b"$'\n'* ]]; then echo "skipped $p (duplicate name)"; S=$((S + 1)); continue; fi
  cp "$p" "$DEST/$b" && { echo "copied $p"; C=$((C + 1)); seen+="$b"$'\n'; }
done < "$LIST"
echo "copied $C, missing $M, skipped $S"
[ $M -eq 0 ] || exit 5

