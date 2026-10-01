#!/bin/bash
dir=$1; shift
for name in "$@"; do
  if [[ -e $dir/$name ]]; then echo "$name: yes"; else echo "$name: no"; fi
done
