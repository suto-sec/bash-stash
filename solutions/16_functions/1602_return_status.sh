#!/bin/bash
es_par() { return $(( $1 % 2 != 0 )); }
for n in "$@"; do
  if es_par "$n"; then echo "$n es par"; else echo "$n es impar"; fi
done

