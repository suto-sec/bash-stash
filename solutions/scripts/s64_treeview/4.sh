#!/bin/bash
max=
if [[ $1 == -d ]]; then
  if (( $# != 3 )); then echo "Error: -d needs a number and a directory" >&2; echo "Usage: $0 [-d N] dir" >&2; exit 1; fi
  max=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 [-d N] dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -n $max && ! $max =~ ^[1-9][0-9]*$ ]]; then echo "Error: '$max' is not a positive integer" >&2; exit 4; fi
while IFS= read -r p; do
  rel=${p#"$1"/}
  depth=$(tr -cd / <<< "$rel" | wc -c)
  [[ -n $max ]] && (( depth + 1 > max )) && continue
  name=${rel##*/}
  [[ -d $p ]] && name+=/
  printf '%*s%s\n' $((depth * 2)) '' "$name"
done < <(find "$1" -mindepth 1 | sort)
exit 0
