#!/bin/bash
# colfreq.sh FILE COLUMN [N] - most frequent values of a CSV column

if [ $# -lt 2 ] || [ $# -gt 3 ]; then
  echo "Usage: $(basename "$0") FILE COLUMN [N]" >&2
  exit 1
fi
FILE=$1 COL=$2 N=${3:-5}
[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 2; }

IDX=$(head -n 1 "$FILE" | tr , '\n' | grep -nxF -- "$COL" | head -n 1 | cut -d: -f1)
[ -n "$IDX" ] || { echo "Error: column '$COL' not found in $FILE" >&2; exit 3; }
[[ $N =~ ^[0-9]+$ ]] && [ "$N" -gt 0 ] || { echo "Error: N must be a positive integer" >&2; exit 4; }

VALUES=$(tail -n +2 "$FILE" | cut -d, -f"$IDX")
echo "$VALUES" | sort | uniq -c | sort -k1,1nr -k2 | head -n "$N" |
  sed -E 's/^ *([0-9]+) (.*)$/\2: \1/'
echo "$(echo "$VALUES" | sort -u | wc -l) distinct values in $(echo "$VALUES" | wc -l) rows"

