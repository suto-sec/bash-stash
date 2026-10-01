#!/bin/bash
if (( $# != 1 )); then echo "Error: one directory is needed" >&2; echo "Usage: $0 dir" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
n=0
while IFS= read -r -d '' f; do
  if [[ $(stat -c %a "$f") != 755 ]]; then chmod 755 "$f"; echo "fixed $f"; n=$((n + 1)); fi
done < <(find "$1" -type f -name "*.sh" -print0)
echo "Fixed $n files"
