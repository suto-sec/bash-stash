#!/bin/bash
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
[[ -s $1 ]] || { echo "Error: $1 is empty" >&2; exit 3; }
sorted=$(sort -n "$1")
echo "$sorted"
echo "min: $(echo "$sorted" | head -n 1)"
echo "max: $(echo "$sorted" | tail -n 1)"
