#!/bin/bash
# expect: 4..8
# the core works (suffix, size, old skipped, destination, count), but no argument is checked
dir=${1:-.}
dest=$HOME/staging
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Created $dest"; fi
n=0
while IFS= read -r -d '' f; do
  cp -f -- "$f" "$dest/" && n=$((n + 1))
done < <(find "$dir" -type d -name old -prune -o -type f \( -name '*.conf' -o -name '*.cfg' \) -size +1024c -print0)
echo "Staged $n files"
