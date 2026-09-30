#!/bin/bash
F=texto.txt
echo "lines=$(wc -l < $F) words=$(wc -w < $F) chars=$(wc -m < $F) bytes=$(wc -c < $F) longest=$(wc -L < $F) blank=$(grep -c '^$' $F)"

