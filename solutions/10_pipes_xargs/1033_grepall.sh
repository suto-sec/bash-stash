#!/bin/bash
# grepall.sh FILE WORD... - lines of FILE that contain all the words

if [ $# -lt 2 ]; then
  echo "Usage: $(basename "$0") FILE WORD..." >&2
  exit 1
fi
FILE=$1; shift
[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 2; }
for w in "$@"; do
  [[ $w =~ ^[A-Za-z]+$ ]] || { echo "Error: invalid word '$w'" >&2; exit 3; }
done

R=$(grep -n '' "$FILE")
for w in "$@"; do
  R=$(grep -iw -- "$w" <<< "$R")
done

M=0
if [ -n "$R" ]; then
  echo "$R"
  M=$(echo "$R" | wc -l)
fi
echo "$M of $(wc -l < "$FILE") lines contain all $# words"
[ "$M" -gt 0 ] || exit 4
