#!/bin/bash
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
n=0 t=0
while read -r -a w; do
  n=$((n + 1)); t=$((t + ${#w[@]}))
  echo "line $n: ${#w[@]} words"
done < "$1"
echo "total: $t words"
