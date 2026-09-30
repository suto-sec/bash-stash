#!/bin/bash
N=$(cat n.txt)
B=$(cat base.txt)
D=$(cat digits.txt)
echo "obase=$B; $N" | bc
echo "ibase=$B; $D" | bc

