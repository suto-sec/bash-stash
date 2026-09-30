#!/bin/bash
# topwords.sh FILE [N]
usage() { echo "Usage: $(basename "$0") FILE [N]" >&2; }
[ $# -ge 1 ] && [ $# -le 2 ] || { usage; exit 1; }
FILE=$1
N=${2:-5}
if [ $# -eq 2 ]; then [[ $N =~ ^[0-9]+$ ]] && [ "$N" -gt 0 ] || { usage; exit 1; }; fi
[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 2; }
WORDS=$(tr -cs 'A-Za-z' '\n' < "$FILE" | tr 'A-Z' 'a-z' | grep -v '^$')
echo "$WORDS" | sort | uniq -c | sort -k1,1nr -k2,2 | head -n "$N" | while read -r c w; do echo "$w $c"; done
TOTAL=$(echo "$WORDS" | sort -u | grep -c .)
echo "Total distinct words: $TOTAL"

