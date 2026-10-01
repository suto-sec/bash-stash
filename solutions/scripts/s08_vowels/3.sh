#!/bin/bash
if (( $# == 0 )); then
  echo "Error: at least one text is needed" >&2
  echo "Usage: $0 text..." >&2
  exit 1
fi
total=0
for t in "$@"; do
  n=$(echo "$t" | tr -cd 'aeiouAEIOU' | wc -c)
  echo "$t: $n"
  total=$((total + n))
done
(( $# > 1 )) && echo "total: $total"
exit 0
