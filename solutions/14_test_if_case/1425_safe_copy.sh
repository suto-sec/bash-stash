#!/bin/bash
# safe_copy.sh [-f] src dst - copy src to dst without overwriting newer files

force=0
if [ "$1" = "-f" ]; then
  force=1
  shift
fi
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") [-f] src dst" >&2
  exit 1
fi
src=$1 dst=$2

if [ ! -e "$src" ]; then
  echo "Error: '$src' does not exist" >&2; exit 2
fi
if [ ! -f "$src" ]; then
  echo "Error: '$src' is not a regular file" >&2; exit 3
fi
if [ ! -r "$src" ]; then
  echo "Error: cannot read '$src'" >&2; exit 4
fi
if [ -d "$dst" ]; then
  target=$dst/$(basename "$src")
else
  target=$dst
  if [ ! -d "$(dirname "$dst")" ]; then
    echo "Error: the directory of '$dst' does not exist" >&2; exit 5
  fi
fi
if [ "$src" -ef "$target" ]; then
  echo "Error: $src and $target are the same file" >&2; exit 6
fi

if [ ! -e "$target" ]; then
  cp "$src" "$target"
  echo "Copied $src -> $target"
elif cmp -s "$src" "$target"; then
  echo "Unchanged $target"
elif [ "$target" -nt "$src" ] && [ $force -eq 0 ]; then
  echo "Kept $target (newer than $src)"
else
  cp "$src" "$target"
  echo "Updated $target"
fi

