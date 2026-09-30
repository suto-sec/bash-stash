#!/bin/bash
# logmonth.sh FILE [N]: chronological order by month, day and time

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Error: wrong number of arguments" >&2
  echo "Usage: $(basename "$0") FILE [N]" >&2
  exit 1
fi
F=$1
if [ ! -f "$F" ] || [ ! -r "$F" ]; then
  echo "Error: cannot read '$F'" >&2
  exit 2
fi
if [ $# -eq 2 ]; then
  N=$2
  if ! [[ $N =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: '$N' is not a positive integer" >&2
    exit 3
  fi
fi

if [ -n "${N:-}" ]; then
  sort -k1,1M -k2,2n -k3,3 -- "$F" | head -n "$N"
else
  sort -k1,1M -k2,2n -k3,3 -- "$F"
fi

