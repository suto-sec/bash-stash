#!/bin/bash
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
n=0
while IFS= read -r line; do
  n=$((n + 1))
  printf '%03d %s\n' "$n" "$line"
done < "$1"
