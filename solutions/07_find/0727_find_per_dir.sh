#!/bin/bash
find logs -type f -name '*.log' | sed 's#/[^/]*$##' | sort | uniq -c | sort -k1,1nr -k2 |
  while read -r n d; do
    echo "$d: $n"
  done

