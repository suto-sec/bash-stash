#!/bin/bash
p=0 t=0
while IFS= read -r name <&3 && IFS= read -r grade <&4; do
  t=$((t + 1))
  if [ "$grade" -ge 5 ]; then
    r=PASS; p=$((p + 1))
  else
    r=FAIL
  fi
  echo "$name: $grade $r"
done 3< nombres.txt 4< notas.txt
echo "passed: $p/$t"

