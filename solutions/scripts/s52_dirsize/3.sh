#!/bin/bash
if (( $# == 0 )); then echo "Error: at least one directory is needed" >&2; echo "Usage: $0 dir..." >&2; exit 1; fi
bad=0 total=0
for d in "$@"; do
  if [[ ! -d $d ]]; then echo "Error: $d is not a directory" >&2; bad=1; continue; fi
  n=$(ls -A "$d" | wc -l)
  echo "$d: $n entries"
  total=$((total + n))
done
(( $# > 1 )) && echo "total: $total entries"
(( bad == 0 )) || exit 2
exit 0
