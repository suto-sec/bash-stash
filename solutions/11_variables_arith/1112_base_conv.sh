#!/bin/bash
N=$(cat n.txt)
printf '%x\n' "$N"
printf '%o\n' "$N"
echo $((16#$(cat hex.txt)))
echo $((2#$(cat bin.txt)))
