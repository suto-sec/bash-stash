#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
while IFS= read -r p; do
  rel=${p#"$1"/}
  depth=$(tr -cd / <<< "$rel" | wc -c)
  name=${rel##*/}
  [[ -d $p ]] && name+=/
  printf '%*s%s\n' $((depth * 2)) '' "$name"
done < <(find "$1" -mindepth 1 | sort)
