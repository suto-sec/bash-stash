#!/bin/bash
n=1
while [[ -e $1.$n ]]; do n=$((n + 1)); done
for ((i = n - 1; i >= 1; i--)); do
  mv -- "$1.$i" "$1.$((i + 1))"
done
cp -- "$1" "$1.1"
: > "$1"
echo "Rotated $1"
