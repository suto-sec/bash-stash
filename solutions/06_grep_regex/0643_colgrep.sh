#!/bin/bash
# colgrep.sh FILE COLNUM PATTERN: lines whose column matches an ERE

if [ $# -ne 3 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE COLNUM PATTERN" >&2
  exit 1
fi
F=$1 C=$2 P=$3
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if ! [[ $C =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: '$C' is not a valid column number" >&2
  exit 3
fi
grep -E -- "$P" /dev/null 2>/dev/null
if [ $? -eq 2 ]; then
  echo "Error: '$P' is not a valid pattern" >&2
  exit 4
fi

MATCHES=$(cut -d: -f"$C" -- "$F" | grep -nE -- "$P" | cut -d: -f1)
if [ -z "$MATCHES" ]; then
  echo "Total: 0 lines"
  exit 0
fi
while IFS= read -r n; do
  sed -n "${n}p" -- "$F"
done <<< "$MATCHES"
echo "Total: $(echo "$MATCHES" | wc -l) lines"
