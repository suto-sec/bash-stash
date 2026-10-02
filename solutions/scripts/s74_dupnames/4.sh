#!/bin/bash
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
n=0
while IFS= read -r name; do
  n=$((n + 1))
  echo "$name"
  find "$dir" -type f -name "$name" | sort | sed 's/^/  /'
done < <(find "$dir" -type f -printf '%f\n' | sort | uniq -d)
if (( n == 0 )); then echo "No repeated names"; exit 4; fi
echo "$n repeated names"
