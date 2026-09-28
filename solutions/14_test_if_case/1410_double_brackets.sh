#!/bin/bash
for a in "$@"; do
  if [[ $a =~ ^([A-Za-z0-9._-]+)@([A-Za-z0-9.-]+\.[A-Za-z]{2,6})$ ]]; then
    echo "email user=${BASH_REMATCH[1]} domain=${BASH_REMATCH[2]}"
  elif [[ $a == *.bak || $a == *~ ]]; then
    echo backup
  else
    echo other
  fi
done

