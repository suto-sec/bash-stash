#!/bin/bash
w=3
if [[ $1 == -w ]]; then
  if (( $# != 3 )); then echo "Error: -w needs a width and a file" >&2; echo "Usage: $0 [-w W] file" >&2; exit 1; fi
  [[ $2 =~ ^[1-9]$ ]] || { echo "Error: '$2' is not a width from 1 to 9" >&2; exit 3; }
  w=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one file is needed" >&2; echo "Usage: $0 [-w W] file" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
n=0
while IFS= read -r line; do
  n=$((n + 1))
  printf "%0${w}d %s\n" "$n" "$line"
done < "$1"
