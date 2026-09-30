#!/bin/bash
i=$1
while [ "$i" -ge 1 ]; do
  echo "$i"
  i=$((i - 1))
done

