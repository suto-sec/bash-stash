#!/bin/bash
# runall.sh DIR [ARG...] - run every executable file of DIR
[ $# -ge 1 ] || { echo "Usage: $(basename "$0") DIR [ARG...]" >&2; exit 1; }
DIR=$1; shift
[ -d "$DIR" ] || { echo "Error: '$DIR' is not a directory" >&2; exit 2; }

ran=0 skipped=0 failed=0
for f in "$DIR"/*; do
  [ -f "$f" ] && [ ! -L "$f" ] || continue
  name=$(basename "$f")
  if [ -x "$f" ]; then
    echo "== $name =="
    "$f" "$@"
    code=$?
    echo "exit: $code"
    ran=$((ran + 1))
    [ $code -ne 0 ] && failed=$((failed + 1))
  else
    echo "skip $name (not executable)"
    skipped=$((skipped + 1))
  fi
done
echo "ran $ran, skipped $skipped, failed $failed"
[ $failed -eq 0 ] || exit 3

