#!/bin/bash
REL=$(cat where.txt)
echo "$REL"
START=$(pwd)
cd "$REL"
ABS=$(pwd)
echo "$ABS"
SUB=${ABS#"$START"/}
UP=..
for ((i = 0; i < $(echo "$SUB" | tr -cd / | wc -c); i++)); do UP="$UP/.."; done
echo "$UP"
