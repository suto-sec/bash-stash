#!/bin/bash
: > .filtrada
while IFS= read -r p; do
  [ -f "proyecto/$p" ] && echo "$p" >> .filtrada
done < lista.txt
tar -C proyecto -czf filtrado.tar.gz -T .filtrada
rm -f .filtrada
tar -tzf filtrado.tar.gz | sort

