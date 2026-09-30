#!/bin/bash
n=0
for f in nuevos/*; do
  [ -f "$f" ] || continue
  name=$(basename "$f")
  if [ -e "archivo/$name" ]; then
    echo "skipped $name"
  else
    cp "$f" archivo/
    n=$((n + 1))
  fi
done
echo "copied $n"

