#!/bin/bash
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 file key" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
line=$(grep -v '^#' "$1" | grep "^$2=" | tail -n 1) || { echo "Error: key $2 not found in $1" >&2; exit 4; }
echo "$line" | cut -d= -f2-
