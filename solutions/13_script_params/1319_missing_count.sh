#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") file..." >&2
  exit 255
fi
missing=0
for f in "$@"; do
  if [ ! -e "$f" ]; then
    echo "missing: $f" >&2
    missing=$((missing + 1))
  fi
done
echo "$(($# - missing)) of $# present"
exit $missing

