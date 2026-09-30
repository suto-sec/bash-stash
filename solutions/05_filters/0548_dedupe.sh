#!/bin/bash
# dedupe.sh FILE: remove repeated lines keeping the first occurrence and the order

if [ $# -ne 1 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE" >&2
  exit 1
fi
F=$1
if [ ! -f "$F" ]; then
  echo "Error: '$F' is not a regular file" >&2
  exit 2
fi
if [ ! -w "$F" ]; then
  echo "Error: '$F' is not writable" >&2
  exit 3
fi

TMP=$(mktemp)
# number the lines, keep the first of each distinct text (stable), restore the order
cat -n "$F" | sort -t$'\t' -k2 -s -u | sort -n | cut -f2- > "$TMP"

L=$(wc -l < "$F") U=$(wc -l < "$TMP")
if [ "$L" -eq "$U" ]; then
  echo "No duplicates in $F"
  rm -f "$TMP"
  exit 0
fi

cp "$F" "$F.bak"
sort "$F" | uniq -cd | sort -k1,1nr -k2 | sed -E 's/^ *([0-9]+) /\1x /'
cat "$TMP" > "$F"                  # cat > keeps the permissions of FILE
rm -f "$TMP"
echo "Removed $((L - U)) duplicate lines ($L -> $U lines)"

