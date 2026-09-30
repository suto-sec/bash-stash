#!/bin/bash
# fixperms.sh DIR FILEMODE DIRMODE - normalise the permissions of a tree
[ $# -eq 3 ] || { echo "Usage: $(basename "$0") DIR FILEMODE DIRMODE" >&2; exit 1; }
DIR=$1 FM=$2 DM=$3
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }
for m in "$FM" "$DM"; do
  [[ $m =~ ^[0-7]{3}$ ]] || { echo "Error: '$m' is not a valid mode" >&2; exit 3; }
done
[[ $DM == 7* ]] || { echo "Error: directories must keep rwx for the owner" >&2; exit 4; }

n=0 total=0
while IFS= read -r p; do
  total=$((total + 1))
  if [ -d "$p" ]; then new=$DM; else new=$FM; fi
  old=$(stat -c %a "$p")
  if [ "$old" != "$new" ]; then
    chmod "$new" "$p"
    echo "$p: $old -> $new"
    n=$((n + 1))
  fi
done < <(find "$DIR" \( -type f -o -type d \) | sort)
echo "Changed $n of $total entries"

