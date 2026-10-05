#!/bin/bash
# expect: 3..7
# arguments are fine, but the old directories are not skipped, and names with spaces break
if (( $# > 1 )); then echo "Error: too many arguments" >&2; echo "Usage: $0 [directory]" >&2; exit 1; fi
dir=${1:-.}
[[ -e $dir ]] || { echo "Error: $dir does not exist" >&2; exit 2; }
[[ -d $dir ]] || { echo "Error: $dir is not a directory" >&2; exit 3; }
dest=$HOME/staging
if [ ! -d $dest ]; then mkdir -p $dest; echo "Created $dest"; fi
n=0
for f in $(find $dir -type f \( -name '*.conf' -o -name '*.cfg' \) -size +1024c); do
  cp $f $dest && n=$((n + 1))
done
echo "Staged $n files"
