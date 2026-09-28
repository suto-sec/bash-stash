#!/bin/bash
(sleep 0.3; exit 3) & P1=$!
(sleep 0.1; exit 0) & P2=$!
(sleep 0.2; exit 7) & P3=$!
T=0; N=1
for P in $P1 $P2 $P3; do
  wait "$P"; C=$?
  echo "job $N: exit $C"
  T=$((T + C)); N=$((N + 1))
done
echo "total: $T"

