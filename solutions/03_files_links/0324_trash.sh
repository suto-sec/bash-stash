#!/bin/bash
# trash.sh FILE... - move files to $HOME/.papelera instead of deleting them
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") FILE..." >&2
  exit 1
fi

TRASH=$HOME/.papelera
if [ ! -d "$TRASH" ]; then
  mkdir -p "$TRASH" || exit 3
  echo "Created $TRASH"
fi

ok=0 errors=0
for f in "$@"; do
  if [ ! -e "$f" ]; then
    echo "Error: '$f' does not exist" >&2; errors=$((errors + 1)); continue
  fi
  if [ -d "$f" ]; then
    echo "Error: '$f' is a directory" >&2; errors=$((errors + 1)); continue
  fi
  name=$(basename "$f")
  dest=$name
  i=1
  while [ -e "$TRASH/$dest" ]; do
    dest=$name.$i
    i=$((i + 1))
  done
  mv "$f" "$TRASH/$dest"
  echo "trashed $f as $dest"
  ok=$((ok + 1))
done

echo "$ok trashed, $errors errors"
[ $errors -eq 0 ] || exit 2

