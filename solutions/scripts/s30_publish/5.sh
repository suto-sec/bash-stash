#!/bin/bash
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/publish
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
n=0 bad=0
while IFS= read -r -d '' f; do
  name=$(basename "$f")
  if [[ $dest/$name -nt $f ]]; then echo "skipped $name" >&2; continue; fi
  if cp -- "$f" "$dest/" 2>/dev/null; then n=$((n + 1)); else echo "could not copy $f" >&2; bad=1; fi
done < <(find "$dir" -type f -name "*.conf" -print0)
echo "Published $n files"
(( bad == 0 )) || exit 4
