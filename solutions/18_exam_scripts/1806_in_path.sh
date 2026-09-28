#!/bin/bash
[ $# -eq 1 ] || { echo "Usage: $(basename "$0") NAME" >&2; exit 2; }
FOUND=0
IFS=:
for d in $PATH; do
  if [ -e "$d/$1" ]; then
    FOUND=1
    if [ -x "$d/$1" ]; then echo "$d/$1 (executable)"; else echo "$d/$1 (not executable)"; fi
  fi
done
[ $FOUND -eq 1 ] || { echo "$1 not found in PATH" >&2; exit 1; }

