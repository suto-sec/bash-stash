#!/bin/bash
if (( $# == 1 )); then
  n=$(grep -c -w -F -- "$1" "$HOME/auth.log")
  echo "$1 appears in $n lines"
  exit 0
fi
for f in "$1"/*.log; do
  [[ -f $f ]] || continue
  n=$(grep -c -w -F -- "$2" "$f")
  (( n > 0 )) && echo "$(basename "$f"): $n"
done
exit 0
