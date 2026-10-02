#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 ref [dir]" >&2; exit 1; fi
ref=$1 dir=${2:-.}
for p in "$ref" "$dir"; do [[ -e $p ]] || { echo "Error: $p does not exist" >&2; exit 2; }; done
[[ -f $ref ]] || { echo "Error: $ref is not a regular file" >&2; exit 3; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
n=0
while IFS= read -r f; do echo "$f"; n=$((n + 1)); done < <(find "$dir" -type f -newer "$ref")
if (( n == 0 )); then echo "Nothing is newer than $ref"; exit 4; fi
echo "$n files newer than $ref"
