#!/bin/bash
for f in "$@"; do
  if [ ! -e "$f" ]; then echo "$f: missing"
  elif [ ! -s "$f" ]; then echo "$f: empty"
  else echo "$f: $(wc -l < "$f") lines"
  fi
done

