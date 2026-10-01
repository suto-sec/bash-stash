#!/bin/bash
# expect: 3..7
# a first working version: right files, no message for the directory, overwrites on collisions, ignores failures
dir=${1:-.}
[[ $# -gt 1 ]] && { echo "usage: $0 [directory]" >&2; exit 1; }
[[ -e $dir ]] || { echo "$dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "$dir is not a directory" >&2; exit 3; }
mkdir -p "$HOME/quarantine"
n=0
while IFS= read -r -d '' f; do
  mv -f -- "$f" "$HOME/quarantine/" 2>/dev/null && { chmod o-w "$HOME/quarantine/$(basename "$f")"; n=$((n + 1)); }
done < <(find "$dir" -type f -perm -002 ! -name '*.tmp' -print0 | sort -z)
echo "Quarantined $n files"
