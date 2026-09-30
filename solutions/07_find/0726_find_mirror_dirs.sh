#!/bin/bash
mkdir -p dst
N=0
while IFS= read -r d; do
  mkdir -p "dst/${d#src/}"
  N=$((N + 1))
done < <(find src -mindepth 1 -type d)
echo "Created $N directories"

