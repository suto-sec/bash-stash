#!/bin/bash
if (( $# < 2 )); then echo "Error: a directory and a name are needed" >&2; echo "Usage: $0 dir name..." >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
dir=$1; shift
for name in "$@"; do
  p=$dir/$name
  if [[ -f $p ]]; then echo "$name: file"
  elif [[ -d $p ]]; then echo "$name: directory"
  elif [[ -e $p ]]; then echo "$name: other"
  else echo "$name: no"; fi
done
