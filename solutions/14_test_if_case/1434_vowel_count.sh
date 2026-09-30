#!/bin/bash
T=0
for w in "$@"; do
  n=0
  i=0
  while [ "$i" -lt "${#w}" ]; do
    c=${w:i:1}
    case $c in
      [aeiouAEIOU]) n=$((n + 1)) ;;
    esac
    i=$((i + 1))
  done
  echo "$w: $n vocales"
  T=$((T + n))
done
echo "total: $T"

