#!/bin/bash
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 dir1 dir2" >&2; exit 1; fi
for d in "$1" "$2"; do [[ -e $d ]] || { echo "Error: $d does not exist" >&2; exit 2; }; done
for d in "$1" "$2"; do [[ -d $d ]] || { echo "Error: $d is not a directory" >&2; exit 3; }; done
n=0
while IFS= read -r name; do echo "$name"; n=$((n + 1)); done < <(comm -23 <(ls "$1" | sort) <(ls "$2" | sort))
if (( n == 0 )); then echo "Nothing only in $1"; exit 4; fi
echo "$n only in $1"
