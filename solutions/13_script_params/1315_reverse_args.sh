#!/bin/bash
if [ $# -eq 0 ]; then
  echo "no arguments"
  exit 0
fi
for ((i = $#; i >= 1; i--)); do
  echo "$i: ${!i}"
done

