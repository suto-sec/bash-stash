#!/bin/bash
if (( $# == 0 )); then echo "Error: no numbers given" >&2; echo "Usage: $0 N..." >&2; exit 1; fi
for n in "$@"; do
  [[ $n =~ ^-?[0-9]+$ ]] || { echo "Error: '$n' is not an integer" >&2; exit 2; }
done
max=$1 min=$1
for n in "$@"; do
  if (( n > max )); then max=$n; fi
  if (( n < min )); then min=$n; fi
done
echo "max: $max"
echo "min: $min"
