#!/bin/bash
usage() { echo "Usage: $0 [directory]" >&2; }
if (( $# > 1 )); then echo "Error: too many arguments" >&2; usage; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/staging
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Created $dest"; fi
n=0
while IFS= read -r -d '' f; do
  cp -f -- "$f" "$dest/" && n=$((n + 1))
done < <(find "$dir" -type d -name old -prune -o -type f \( -name '*.conf' -o -name '*.cfg' \) -size +1024c -print0)
echo "Staged $n files"
