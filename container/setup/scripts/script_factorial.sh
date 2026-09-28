#!/bin/bash
# Usage: script_factorial.sh N
n=${1:-5}
f=1
i=1
while [ $i -le $n ]
do
  f=$((f*i))
  i=$((i+1))
done
echo "$n! = $f"
