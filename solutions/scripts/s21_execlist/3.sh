#!/bin/bash
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/bin
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
while IFS= read -r -d '' f; do
  cp -- "$f" "$dest/"
done < <(find "$dir" -type f -name "*.sh" -perm /111 -print0)
