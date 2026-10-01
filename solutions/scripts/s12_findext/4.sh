#!/bin/bash
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 ext [dir]" >&2; exit 1; fi
dir=${2:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
n=0
while IFS= read -r f; do
  echo "$f"; n=$((n + 1))
done < <(find "$dir" -type f -name "*.$1")
echo "Found $n files"
