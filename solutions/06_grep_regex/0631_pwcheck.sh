#!/bin/bash
# pwcheck.sh FILE
if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") FILE" >&2
  exit 1
fi
F=$1
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
OK='[a-z_][a-z0-9_-]*:[^:]*:[0-9]+:[0-9]+:[^:]*:[^:]*:[^:]+'

# numbered lines that are not ignored, and among them the ones that do not match
BAD=$(grep -nvE '^(#|$)' "$F" | grep -vE "^[0-9]+:$OK$")
if [ -n "$BAD" ]; then
  while IFS= read -r l; do echo "line ${l%%:*}: ${l#*:}"; done <<< "$BAD" >&2
fi
grep -xE "$OK" "$F" | cut -d: -f7 | sort | uniq -c | sort -k1,1nr -k2 | sed 's/^ *//'
U=$(grep -cxE "$OK" "$F")
M=$(grep -c . <<< "$BAD")
echo "$U users, $M malformed"
[ "$M" -eq 0 ] || exit 4

