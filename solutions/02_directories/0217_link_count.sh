#!/bin/bash
for d in proj/*/; do
  L=$(stat -c %h "$d")
  echo "$(basename "$d"): links=$L subdirs=$((L - 2))"
done
L=$(stat -c %h proj)
echo "proj: links=$L subdirs=$((L - 2))"

