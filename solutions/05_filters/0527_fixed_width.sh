#!/bin/bash
F=inventario.txt
paste -d';' <(cut -c1-6 "$F" | sed 's/ *$//') \
            <(cut -c7-26 "$F" | sed 's/ *$//') \
            <(cut -c27-31 "$F" | tr -d ' ') |
  sort -t';' -k3,3nr -k1,1

