#!/bin/bash
read -r NAME QTY PRICE < order.txt
TOTAL=$((QTY * PRICE))
printf 'Item      : %s\n' "$NAME"
printf 'Quantity  : %8d\n' "$QTY"
printf 'Unit price: %8s EUR\n' "$((PRICE / 100)).$(printf '%02d' $((PRICE % 100)))"
printf 'Total     : %8s EUR\n' "$((TOTAL / 100)).$(printf '%02d' $((TOTAL % 100)))"

