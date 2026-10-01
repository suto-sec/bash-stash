#!/bin/bash
usage() { echo "Usage: $0 [directory]" >&2; }
if (( $# > 1 )); then echo "Error: too many arguments" >&2; usage; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
newest=
while IFS= read -r -d '' f; do
  if [[ -z $newest || $f -nt $newest ]]; then newest=$f; fi
done < <(find "$dir" -maxdepth 1 -type f -print0)
[[ -n $newest ]] || { echo "Error: no regular files in $dir" >&2; exit 4; }
echo "$(basename "$newest") ($(stat -c %s "$newest") bytes)"
