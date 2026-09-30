#!/bin/bash
declare -A cnt
t=0
while IFS= read -r name; do
  case $name in
    *.sh) cat=scripts ;;
    *.txt | *.md) cat=docs ;;
    *.jpg | *.png | *.gif) cat=imagenes ;;
    *) cat=otros ;;
  esac
  echo "$name -> $cat"
  cnt[$cat]=$(( ${cnt[$cat]:-0} + 1 ))
  t=$((t + 1))
done < entradas.txt
for k in "${!cnt[@]}"; do echo "$k: ${cnt[$k]}"; done | sort
echo "TOTAL: $t"

