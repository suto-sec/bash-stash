#!/bin/bash
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [dir]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
while IFS= read -r -d '' f; do
  head -n 1 "$f" | grep -q '^#!' || echo "$f: no shebang"
  [[ -x $f ]] || echo "$f: not executable"
done < <(find "$dir" -type f -name '*.sh' -print0)
exit 0
