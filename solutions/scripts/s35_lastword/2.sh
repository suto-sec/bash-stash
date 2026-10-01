#!/bin/bash
while read -r -a w; do
  (( ${#w[@]} )) && echo "${w[-1]}"
done < "$1"
exit 0
