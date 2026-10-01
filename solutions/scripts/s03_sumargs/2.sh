#!/bin/bash
if (( $# == 0 )); then
  echo "Error: no numbers given" >&2
  echo "Usage: $0 number..." >&2
  exit 1
fi
total=0
for n in "$@"; do
  total=$((total + n))
done
echo "Total: $total"
