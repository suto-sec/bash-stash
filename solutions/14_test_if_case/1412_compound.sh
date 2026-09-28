#!/bin/bash
for f in "$@"; do
  if [ -f "$f" ] && [ -r "$f" ] && [ -s "$f" ] && { [ -x "$f" ] || [[ $f == *.sh ]]; }; then
    echo "$f: OK"
  else
    echo "$f: KO"
  fi
done

