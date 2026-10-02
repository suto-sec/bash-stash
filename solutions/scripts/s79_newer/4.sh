#!/bin/bash
copy=
if [[ $1 == -c ]]; then copy=1; shift; fi
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 [-c] ref [dir]" >&2; exit 1; fi
ref=$1 dir=${2:-.}
for p in "$ref" "$dir"; do [[ -e $p ]] || { echo "Error: $p does not exist" >&2; exit 2; }; done
[[ -f $ref ]] || { echo "Error: $ref is not a regular file" >&2; exit 3; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/newer
if [[ -n $copy && ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
n=0
while IFS= read -r -d '' f; do
  n=$((n + 1))
  if [[ -n $copy ]]; then cp -- "$f" "$dest/"; echo "copied $f"; else echo "$f"; fi
done < <(find "$dir" -type f -newer "$ref" -print0)
if (( n == 0 )); then echo "Nothing is newer than $ref"; exit 4; fi
echo "$n files newer than $ref"
