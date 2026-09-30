#!/bin/bash
l=0; w=0; c=0; max=-1
while IFS= read -r line; do
  l=$((l + 1))
  read -ra ws <<< "$line"
  w=$((w + ${#ws[@]}))
  c=$((c + ${#line} + 1))
  if [ ${#line} -gt $max ]; then max=${#line}; ml=$l; fi
done < texto.txt
echo "lines: $l"
echo "words: $w"
echo "chars: $c"
echo "longest: $max chars (line $ml)"

