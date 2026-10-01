#!/bin/bash
if (( $# != 2 )); then echo "Error: a directory and a link directory are needed" >&2; echo "Usage: $0 dir linkdir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -e $2 && ! -d $2 ]]; then echo "Error: $2 is not a directory" >&2; exit 3; fi
if [[ ! -d $2 ]]; then mkdir -p "$2"; echo "Directory $2 created"; fi
for f in "$1"/*; do
  [[ -f $f ]] || continue
  ln -s "$(readlink -f "$f")" "$2/$(basename "$f")"
  echo "linked $(basename "$f")"
done
exit 0
