#!/bin/bash
# relink.sh DIR OLD NEW - rewrite symbolic links that point below OLD so they point below NEW
if [ $# -ne 3 ]; then
  echo "Usage: $(basename "$0") DIR OLD NEW" >&2
  exit 1
fi
DIR=$1 OLD=$2 NEW=$3
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
[ -n "$OLD" ] && [ -n "$NEW" ] || { echo "Error: OLD and NEW must not be empty" >&2; exit 3; }

n=0 total=0
while IFS= read -r l; do
  total=$((total + 1))
  t=$(readlink "$l")
  if [ "$t" = "$OLD" ] || [[ $t == "$OLD"/* ]]; then
    new=$NEW${t#"$OLD"}
    ln -sfn "$new" "$l"          # -n: do not follow the old link if it points to a directory
    echo "$l: $t -> $new"
    n=$((n + 1))
  fi
done < <(find "$DIR" -type l | sort)
echo "Relinked $n of $total links"

