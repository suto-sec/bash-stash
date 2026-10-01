#!/bin/bash
if (( $# < 2 )); then echo "Error: a directory and a name are needed" >&2; echo "Usage: $0 dir name..." >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
dir=$1; shift
for name in "$@"; do
  if [[ -e $dir/$name ]]; then echo "$name: yes"; else echo "$name: no"; fi
done
