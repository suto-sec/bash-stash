#!/bin/bash
n=$1
while (( n > 0 )); do
  echo "$n"
  n=$((n - 1))
done
echo "Liftoff!"
