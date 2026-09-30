#!/bin/bash
# dedup.sh DIR - replace duplicate files by hard links to the first copy
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") DIR" >&2; exit 1; }
DIR=$1
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

n=0 bytes=0
for f in "$DIR"/*; do
  [ -f "$f" ] && [ ! -L "$f" ] && [ -s "$f" ] || continue
  for g in "$DIR"/*; do
    [ "$g" = "$f" ] && break                       # only files before f
    [ -f "$g" ] && [ ! -L "$g" ] && [ -s "$g" ] || continue
    if cmp -s "$f" "$g"; then
      if [ ! "$f" -ef "$g" ]; then
        size=$(stat -c %s "$f")
        ln -f "$g" "$f"
        echo "$(basename "$f") => $(basename "$g")"
        n=$((n + 1)); bytes=$((bytes + size))
      fi
      break
    fi
  done
done
echo "Linked $n files, saved $bytes bytes"

