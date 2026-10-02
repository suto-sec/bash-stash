#!/bin/bash
fix=
if [[ $1 == -f ]]; then fix=1; shift; fi
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [-f] [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
while IFS= read -r -d '' f; do
  if [[ -n $fix ]]; then chmod o-w -- "$f"; echo "fixed $f"; else echo "$f"; fi
done < <(find "$dir" -type f -perm -o+w -print0)
