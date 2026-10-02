#!/bin/bash
fix=
if [[ $1 == -f ]]; then fix=1; shift; fi
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [-f] [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
n=0
while IFS= read -r -d '' f; do
  n=$((n + 1))
  if [[ -n $fix ]]; then chmod o-w -- "$f"; echo "fixed $f"; else echo "$f"; fi
done < <(find "$dir" -type f -perm -o+w -print0)
if [[ -n $fix ]]; then echo "Fixed $n files"; else echo "$n world-writable files"; (( n == 0 )) || exit 4; fi
