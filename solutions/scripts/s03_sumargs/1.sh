#!/bin/bash
total=0
for n in "$@"; do
  total=$((total + n))
done
echo "Total: $total"
