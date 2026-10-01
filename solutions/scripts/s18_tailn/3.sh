#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 file [N]" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
n=${2:-5}
[[ $n =~ ^[1-9][0-9]*$ ]] || { echo "Error: '$n' is not a positive integer" >&2; exit 3; }
tail -n "$n" "$1"
