#!/bin/bash
while read -r -a w; do
  if (( ${#w[@]} )); then echo "${w[-1]}"; else echo; fi
done < "$1"
