#!/bin/bash
P=$(cat leaf.txt)
rmdir -p "$P" 2> /dev/null
while [ "$P" != . ]; do
  if [ -d "$P" ]; then echo "kept $P"; else echo "removed $P"; fi
  P=$(dirname "$P")
done

