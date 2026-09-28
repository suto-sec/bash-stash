#!/bin/bash
for j in *.txt
do
  echo "Copiando $j en $j.bak"
  cp $j $j".bak"
done
