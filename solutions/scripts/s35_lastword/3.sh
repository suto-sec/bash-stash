#!/bin/bash
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
while read -r -a w; do
  (( ${#w[@]} )) && echo "${w[-1]}"
done < "$1"
exit 0
