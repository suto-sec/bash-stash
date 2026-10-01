#!/bin/bash
usage() { echo "Usage: $0 [directory]" >&2; }
if (( $# > 1 )); then echo "Error: too many arguments" >&2; usage; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/quarantine
if [[ ! -d $dest ]]; then mkdir -p "$dest"; echo "Directory $dest created"; fi
n=0 bad=0
while IFS= read -r -d '' f; do
  name=$(basename "$f") t=$dest/$(basename "$f") k=0
  while [[ -e $t ]]; do k=$((k + 1)); t=$dest/$name.$k; done
  if mv -- "$f" "$t" 2>/dev/null; then chmod o-w "$t"; n=$((n + 1)); else echo "could not move $f" >&2; bad=$((bad + 1)); fi
done < <(find "$dir" -type f -perm -002 ! -name '*.tmp' -print0 | sort -z)
echo "Quarantined $n files"
(( bad == 0 )) || exit 4
