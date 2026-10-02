#!/bin/bash
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
n=0
while IFS= read -r p; do
  echo "$p"; n=$((n + 1))
done < <(find "$dir" -mindepth 1 -name '[ab]*' ! -name '*~*')
echo "Found $n entries"
(( n > 0 )) || exit 4
