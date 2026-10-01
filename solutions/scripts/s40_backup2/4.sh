#!/bin/bash
if (( $# != 2 )); then echo "Error: a source and a destination are needed" >&2; echo "Usage: $0 src dst" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -e $2 && ! -d $2 ]]; then echo "Error: $2 is not a directory" >&2; exit 3; fi
if [[ ! -d $2 ]]; then mkdir -p "$2"; echo "Directory $2 created"; fi
n=0 bad=0
while IFS= read -r -d '' f; do
  rel=${f#"$1"/}
  if [[ -e $2/.last && ! $f -nt $2/.last ]]; then continue; fi
  mkdir -p "$2/$(dirname "$rel")"
  if cp -- "$f" "$2/$rel" 2>/dev/null; then echo "copied $rel"; n=$((n + 1)); else echo "could not copy $rel" >&2; bad=1; fi
done < <(find "$1" -type f -print0)
touch "$2/.last"
echo "Copied $n files"
(( bad == 0 )) || exit 4
