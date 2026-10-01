#!/bin/bash
if (( $# != 2 )); then echo "Error: a source and a destination are needed" >&2; echo "Usage: $0 src dst" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -e $2 && ! -d $2 ]]; then echo "Error: $2 is not a directory" >&2; exit 3; fi
if [[ ! -d $2 ]]; then mkdir -p "$2"; echo "Directory $2 created"; fi
while IFS= read -r -d '' f; do
  rel=${f#"$1"/}
  if [[ -e $2/.last && ! $f -nt $2/.last ]]; then continue; fi
  mkdir -p "$2/$(dirname "$rel")"
  cp -- "$f" "$2/$rel" 2>/dev/null && echo "copied $rel"
done < <(find "$1" -type f -print0)
touch "$2/.last"
exit 0
