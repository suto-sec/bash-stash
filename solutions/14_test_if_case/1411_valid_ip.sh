#!/bin/bash
ip=$1
if [[ $ip =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
  for i in 1 2 3 4; do
    (( 10#${BASH_REMATCH[i]} > 255 )) && { echo invalid; exit 1; }
  done
  echo valid
  exit 0
fi
echo invalid
exit 1

