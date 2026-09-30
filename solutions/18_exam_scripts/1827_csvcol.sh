#!/bin/bash
# csvcol.sh FILE COL
usage() { echo "Usage: $(basename "$0") FILE COL" >&2; }
[ $# -eq 2 ] || { usage; exit 1; }
FILE=$1
COL=$2
[[ $COL =~ ^[0-9]+$ ]] && [ "$COL" -gt 0 ] || { usage; exit 1; }
[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 2; }
cut -d, -f"$COL" "$FILE"
N=$(wc -l < "$FILE")
echo "Total: $N lines"

