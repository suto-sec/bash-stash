#!/bin/bash
D=$(cat descuento.txt)
TOTAL_ORIG=0
TOTAL_DESC=0
while IFS= read -r p; do
  desc=$(echo "scale=2; $p - $p * $D / 100" | bc)
  echo "$desc"
  TOTAL_ORIG=$(echo "scale=2; $TOTAL_ORIG + $p" | bc)
  TOTAL_DESC=$(echo "scale=2; $TOTAL_DESC + $desc" | bc)
done < precios.txt
echo "$TOTAL_DESC"
echo "scale=2; $TOTAL_ORIG - $TOTAL_DESC" | bc

