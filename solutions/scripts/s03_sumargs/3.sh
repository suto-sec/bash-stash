#!/bin/bash
if (( $# == 0 )); then
  echo "Error: no numbers given" >&2
  echo "Usage: $0 number..." >&2
  exit 1
fi
for n in "$@"; do
  if [[ ! $n =~ ^[0-9]+$ ]]; then
    echo "Error: '$n' is not a non-negative integer" >&2
    exit 2
  fi
done
total=0
for n in "$@"; do
  total=$((total + n))
done
echo "Total: $total"
