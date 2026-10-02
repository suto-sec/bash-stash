#!/bin/bash
del=
if [[ $1 == -d ]]; then del=1; shift; fi
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [-d] [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
find "$dir" -type f -print0 | sort -z | xargs -0 -r md5sum | awk '{h=$1; sub(/^[^ ]+  /, ""); if (seen[h]++) print}' | sort | while IFS= read -r f; do
  if [[ -n $del ]]; then rm -- "$f"; echo "removed $f"; else echo "$f"; fi
done
exit 0
