#!/bin/bash
SUM=$(paste -sd+ notas.txt | bc)
N=$(wc -l < notas.txt)
echo "$SUM"
echo "scale=2; $SUM / $N" | bc
echo "scale=5; sqrt(2)" | bc

