#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
n=0 bad=0
for f in "$1"/*; do
  [[ -f $f ]] || continue
  name=$(basename "$f")
  if [[ $name == *.* ]]; then ext=${name##*.}; else ext=noext; fi
  if [[ ! -d $1/$ext ]]; then
    if mkdir -p "$1/$ext" 2>/dev/null; then echo "Directory $1/$ext created"; else echo "could not move $name" >&2; bad=1; continue; fi
  fi
  target=$name; k=0
  while [[ -e $1/$ext/$target ]]; do k=$((k + 1)); target=$name.$k; done
  [[ $target != "$name" ]] && echo "renamed $name to $target"
  if mv -- "$f" "$1/$ext/$target" 2>/dev/null; then n=$((n + 1)); else echo "could not move $name" >&2; bad=1; fi
done
echo "Moved $n files"
(( bad == 0 )) || exit 4
