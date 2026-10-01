#!/bin/bash
out=
for w in $1; do
  out+=${w:0:1}
done
echo "${out^^}"
