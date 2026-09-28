#!/bin/bash
i=$1
until [ "$i" -lt 0 ]; do
  echo "T-$i"
  i=$((i - 1))
done
echo "Liftoff!"
p=1
out=
while [ $p -lt 1000 ]; do
  out+="$p "
  p=$((p * 2))
done
echo $out

