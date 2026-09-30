#!/bin/bash
# permsave.sh save|restore DIR FILE
[ $# -eq 3 ] || { echo "Usage: $(basename "$0") save|restore DIR FILE" >&2; exit 1; }
ACTION=$1 DIR=$2 FILE=$3
case $ACTION in
  save|restore) ;;
  *) echo "Error: unknown action '$ACTION'" >&2; exit 2 ;;
esac
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 3; }

if [ "$ACTION" = save ]; then
  n=0
  while IFS= read -r p; do
    echo "$(stat -c %a "$DIR/$p") $p"
    n=$((n + 1))
  done < <(cd "$DIR" && find . -mindepth 1 \( -type f -o -type d \) | sed 's#^\./##' | sort) > "$FILE"
  echo "Saved $n entries to $FILE"
  exit 0
fi

[ -f "$FILE" ] && [ -r "$FILE" ] || { echo "Error: cannot read '$FILE'" >&2; exit 4; }
n=0 missing=0
while read -r mode p; do
  if [ ! -e "$DIR/$p" ]; then
    echo "missing $p" >&2
    missing=$((missing + 1))
    continue
  fi
  old=$(stat -c %a "$DIR/$p")
  if [ "$old" != "$mode" ]; then
    chmod "$mode" "$DIR/$p"
    echo "restored $p: $old -> $mode"
    n=$((n + 1))
  fi
done < "$FILE"
echo "Restored $n entries, $missing missing"

