#!/bin/bash
for d in "$@"; do
  if [ ! -e "$d" ]; then
    echo "$d: not found"
  elif [ ! -d "$d" ]; then
    echo "$d: not a directory"
  elif [ ! -r "$d" ] || [ ! -x "$d" ]; then
    echo "$d: no access"
  else
    n=$(ls -A "$d" | wc -l)
    if [ "$n" -eq 0 ]; then
      echo "$d: empty"
    else
      echo "$d: $n entries"
    fi
  fi
done

