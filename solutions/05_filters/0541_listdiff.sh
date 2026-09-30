#!/bin/bash
# listdiff.sh OLD NEW: items removed / added between two lists

if [ $# -ne 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") OLD NEW" >&2
  exit 2
fi
for f in "$1" "$2"; do
  if [ ! -f "$f" ] || [ ! -r "$f" ]; then
    echo "Error: cannot read '$f'" >&2
    exit 3
  fi
done

OLD=$(mktemp) NEW=$(mktemp)
sed '/^$/d' "$1" | sort -u > "$OLD"
sed '/^$/d' "$2" | sort -u > "$NEW"

D=$(diff "$OLD" "$NEW")
echo "$D" | grep '^< ' | sed 's/^< /- /'
echo "$D" | grep '^> ' | sed 's/^> /+ /'
R=$(echo "$D" | grep -c '^< ')
A=$(echo "$D" | grep -c '^> ')
K=$(( $(wc -l < "$OLD") - R ))
rm -f "$OLD" "$NEW"

echo "Removed: $R, added: $A, kept: $K"
if [ $((R + A)) -eq 0 ]; then exit 0; else exit 1; fi

