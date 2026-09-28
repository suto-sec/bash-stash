#!/bin/bash
for ((i = 1; i <= 5; i++)); do
  ./flaky.sh
  c=$?
  echo "attempt $i: exit $c"
  if [ $c -eq 0 ]; then echo "success after $i attempts"; exit 0; fi
done
echo "giving up after 5 attempts"
exit 1
