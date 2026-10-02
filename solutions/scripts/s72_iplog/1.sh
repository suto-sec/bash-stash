#!/bin/bash
for f in "$1"/*.log; do
  [[ -f $f ]] || continue
  n=$(grep -c -w -F -- "$2" "$f")
  (( n > 0 )) && echo "$(basename "$f"): $n"
done
exit 0
