#!/bin/bash
n=0; k=0; b=0
while IFS= read -r line; do
  n=$((n + 1))
  [[ -z $line || $line == \#* ]] && continue
  key=${line%%=*}
  if [[ $line != *=* || -z $key ]]; then
    echo "line $n: ignored"; b=$((b + 1)); continue
  fi
  echo "$key=[${line#*=}]"
  k=$((k + 1))
done < app.conf
echo "$k settings, $b ignored"

