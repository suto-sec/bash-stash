#!/bin/bash
if (( $# == 0 )); then
  echo "Error: at least one file is needed" >&2
  echo "Usage: $0 file..." >&2
  exit 1
fi
total=0 bad=0 good=0
for f in "$@"; do
  if [[ ! -f $f ]]; then echo "Error: $f is not a regular file" >&2; bad=1; continue; fi
  if [[ ! -r $f ]]; then echo "Error: cannot read $f" >&2; bad=1; continue; fi
  n=$(wc -l < "$f")
  echo "$f: $n"
  total=$((total + n)); good=$((good + 1))
done
(( $# > 1 )) && (( good > 0 )) && echo "total: $total"
(( bad == 0 )) || exit 2
