#!/bin/bash
mkdir -p resultados
for f in datos/*.txt; do
  n=$(basename "$f")
  wc -l < "$f" > "resultados/$n.count" &
done
wait
cat resultados/*.count | paste -sd+ | bc

