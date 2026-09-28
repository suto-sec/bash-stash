#!/bin/bash
for f in *.txt; do
  [ -e "$f" ] || continue
  echo "$f: $(wc -l < "$f") lines"
  cp "$f" "$f.bak"
done

