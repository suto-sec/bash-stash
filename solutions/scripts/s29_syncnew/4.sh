#!/bin/bash
if (( $# != 2 )); then echo "Error: a source and a destination are needed" >&2; echo "Usage: $0 src dst" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
if [[ -e $2 && ! -d $2 ]]; then echo "Error: $2 is not a directory" >&2; exit 3; fi
if [[ ! -d $2 ]]; then mkdir -p "$2"; echo "Directory $2 created"; fi
n=0 bad=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ ! -e $2/$name || $f -nt $2/$name ]]; then
    if cp -- "$f" "$2/" 2>/dev/null; then echo "copied $name"; n=$((n + 1)); else echo "could not copy $name" >&2; bad=1; fi
  fi
done
echo "Copied $n files"
(( bad == 0 )) || exit 4
