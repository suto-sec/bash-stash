#!/bin/bash
n=1
if [[ $1 == -n ]]; then
  if (( $# != 3 )); then echo "Error: -n needs a number and a directory" >&2; echo "Usage: $0 [-n N] dir" >&2; exit 1; fi
  n=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 [-n N] dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
[[ $n =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$n' is not a positive integer" >&2; exit 4; }
find "$1" -type f -printf '%s %p\n' | sort -k1,1nr -k2 | head -n "$n"
exit 0
