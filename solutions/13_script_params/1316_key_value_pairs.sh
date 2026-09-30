#!/bin/bash
if (( $# % 2 != 0 )); then
  echo "Odd number of arguments ($#)" >&2
  exit 1
fi
i=1
for a in "$@"; do
  # keys are at odd positions
  if (( i % 2 == 1 )) && [ -z "$a" ]; then
    echo "Empty key at position $i" >&2
    exit 2
  fi
  i=$((i + 1))
done
n=0
while [ $# -gt 0 ]; do
  echo "$1 = $2"
  n=$((n + 1))
  shift 2
done
echo "$n pairs"

