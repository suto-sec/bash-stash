#!/bin/bash
cd fotos
for f in *; do
  n=${f// /_}
  [[ $n == *.jpeg ]] && n=${n%.jpeg}.jpg
  if [ "$f" != "$n" ]; then
    mv "$f" "$n"
    echo "$f -> $n"
  fi
done

