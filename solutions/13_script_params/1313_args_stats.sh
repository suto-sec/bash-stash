#!/bin/bash
[ $# -eq 0 ] && { echo "No numbers" >&2; exit 1; }
for n in "$@"; do
  [[ $n =~ ^-?[0-9]+$ ]] || { echo "Not a number: $n" >&2; exit 2; }
done
S=0; MIN=$1; MAX=$1
for n in "$@"; do
  S=$((S + n))
  [ "$n" -lt "$MIN" ] && MIN=$n
  [ "$n" -gt "$MAX" ] && MAX=$n
done
echo "count: $#"
echo "sum: $S"
echo "min: $MIN"
echo "max: $MAX"
