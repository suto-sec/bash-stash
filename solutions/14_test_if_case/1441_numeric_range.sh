#!/bin/bash
# numeric_range.sh MIN MAX VALUE...
if [ $# -lt 3 ]; then
  echo "usage: $(basename "$0") MIN MAX VALUE..." >&2
  exit 1
fi
MIN=$1; MAX=$2; shift 2
if ! [[ $MIN =~ ^-?[0-9]+$ ]]; then
  echo "error: '$MIN' is not a valid integer" >&2
  exit 2
fi
if ! [[ $MAX =~ ^-?[0-9]+$ ]]; then
  echo "error: '$MAX' is not a valid integer" >&2
  exit 2
fi
if [ "$MIN" -gt "$MAX" ]; then
  echo "error: MIN is greater than MAX" >&2
  exit 3
fi
D=0; F=0
for v in "$@"; do
  if [[ $v =~ ^-?[0-9]+$ ]] && [ "$v" -ge "$MIN" ] && [ "$v" -le "$MAX" ]; then
    echo "$v: dentro"
    D=$((D + 1))
  else
    echo "$v: fuera de rango"
    F=$((F + 1))
  fi
done
echo "TOTAL: $D dentro, $F fuera"
