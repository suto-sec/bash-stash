#!/bin/bash
N=$(cat n.txt)
echo $(seq -f 'part%g' "$N")
echo $(printf 'img_%03d.png\n' $(seq "$N"))
echo $(seq "$N" -2 1)
echo "$(seq -s + "$N")=$((N * (N + 1) / 2))"

