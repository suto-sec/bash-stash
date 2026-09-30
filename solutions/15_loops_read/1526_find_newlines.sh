#!/bin/bash
n=0; s=0
while IFS= read -r -d '' f; do
  size=$(stat -c %s "$f")
  [ "$size" -ge "$1" ] || continue
  echo "${f//$'\n'/?} ($size bytes)"
  n=$((n + 1)); s=$((s + size))
done < <(find datos -type f -print0 | sort -z)
echo "$n files, $s bytes"

