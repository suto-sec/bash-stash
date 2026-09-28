#!/bin/bash
for y in "$@"; do
  if (( (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 )); then echo "$y: leap"
  else echo "$y: not leap"
  fi
done
