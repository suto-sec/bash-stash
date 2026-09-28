#!/bin/bash
for m in 700 600 300; do
  chmod "$m" caja
  l=no; c=no; t=no
  ls caja > /dev/null 2>&1 && l=yes
  (cd caja) 2> /dev/null && c=yes
  touch caja/nuevo 2> /dev/null && t=yes && rm -f caja/nuevo
  echo "$m ls:$l cd:$c create:$t"
done
chmod 755 caja

