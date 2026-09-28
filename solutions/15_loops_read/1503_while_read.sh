#!/bin/bash
n=1
while IFS= read -r line || [ -n "$line" ]; do
  echo "$n: $line"
  n=$((n + 1))
done < entrada.txt

