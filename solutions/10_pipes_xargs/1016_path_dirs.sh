#!/bin/bash
for d in $(echo "$PATH" | tr : ' '); do
  [ -e "$d/$1" ] && echo "$d/$1"
done
exit 0
