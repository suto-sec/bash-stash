#!/bin/bash
for i in {1..10}; do
  echo "$1 x $i = $(($1 * i))"
done
