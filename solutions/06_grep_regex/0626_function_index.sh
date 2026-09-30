#!/bin/bash
grep -nHE '^[A-Za-z_][A-Za-z0-9_]*\(\)' scripts/*.sh |
  while IFS=: read -r file line text; do
    echo "${text%%(*} $file:$line"
  done | sort

