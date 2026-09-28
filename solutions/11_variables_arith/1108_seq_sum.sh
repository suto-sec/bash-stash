#!/bin/bash
N=$(cat n.txt)
seq -s ' ' 1 "$N"
seq 2 2 $((2 * N))
seq -s+ 1 "$N" | bc
echo $((N * (N + 1) / 2))

