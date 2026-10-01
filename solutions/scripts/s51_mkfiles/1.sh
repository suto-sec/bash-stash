#!/bin/bash
for ((i = 1; i <= $2; i++)); do
  touch -- "$1$i"
done
echo "Created $2 files"
