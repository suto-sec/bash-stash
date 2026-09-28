#!/bin/bash
for ((i = 1; i <= $1; i++)); do
  row=
  for ((j = 1; j <= $1; j++)); do
    row+="$((i * j))"
    [ $j -lt $1 ] && row+=$'\t'
  done
  echo "$row"
done

