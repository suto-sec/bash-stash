#!/bin/bash
k=0
select f in *.txt quit; do
  if [ -z "$f" ]; then
    echo "invalid choice: $REPLY"
  elif [ "$f" = quit ]; then
    echo bye; break
  else
    echo "$f: $(wc -l < "$f") lines"; k=$((k + 1))
  fi
done
echo "shown $k files"

