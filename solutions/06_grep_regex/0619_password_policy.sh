#!/bin/bash
OK=$(grep -E '.{8,}' candidatas.txt | grep '[[:digit:]]' | grep '[[:upper:]]' | grep '[[:lower:]]' | grep '[[:punct:]]')
[ -n "$OK" ] && echo "$OK"
echo ---
echo $(( $(wc -l < candidatas.txt) - $(grep -c . <<< "$OK") ))

