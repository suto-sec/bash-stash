#!/bin/bash
# caja.sh TEXT [CHAR] - draws TEXT inside a box

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") TEXT [CHAR]" >&2
  exit 1
fi
TEXT=$1
C=${2-#}
if [ ${#C} -ne 1 ]; then
  echo "Error: CHAR must be exactly one character, got '$C'" >&2
  exit 2
fi
if [ -z "$TEXT" ] || [ ${#TEXT} -gt 40 ]; then
  echo "Error: TEXT must have between 1 and 40 characters" >&2
  exit 3
fi

W=$(( ${#TEXT} + 4 ))
BORDER=$(printf "%${W}s" "" | tr ' ' "$C")
printf '%s\n' "$BORDER"
printf '%s %s %s\n' "$C" "$TEXT" "$C"
printf '%s\n' "$BORDER"
echo "Box: 3 lines, $W columns"

