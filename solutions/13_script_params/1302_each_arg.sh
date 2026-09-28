#!/bin/bash
i=1
for a in "$@"; do
  echo "Arg $i: $a"
  i=$((i + 1))
done

