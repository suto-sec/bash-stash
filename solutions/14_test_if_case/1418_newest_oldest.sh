#!/bin/bash
newest= oldest=
for f in "$@"; do
  if [ ! -e "$f" ]; then
    echo "ignored: $f" >&2
    continue
  fi
  if [ -z "$newest" ]; then
    newest=$f oldest=$f
    continue
  fi
  [ "$f" -nt "$newest" ] && newest=$f
  [ "$f" -ot "$oldest" ] && oldest=$f
done
if [ -z "$newest" ]; then
  echo "no files" >&2
  exit 1
fi
echo "newest: $newest"
echo "oldest: $oldest"

