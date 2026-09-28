#!/bin/bash
cd "$1" || exit 1
d=0; f=0; l=0
for e in $(ls -A); do
  if [ -L "$e" ]; then echo "[L] $e -> $(readlink "$e")"; l=$((l + 1))
  elif [ -d "$e" ]; then echo "[D] $e ($(ls -A "$e" | wc -l) entries)"; d=$((d + 1))
  elif [ -f "$e" ]; then echo "[F] $e ($(stat -c %s "$e") bytes)"; f=$((f + 1))
  fi
done
echo "Total: $d dirs, $f files, $l links"

