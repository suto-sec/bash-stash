#!/bin/bash
s=()
for n in "$1" "$2" "$3"; do
  if [ "$n" -gt 0 ]; then s+=(+)
  elif [ "$n" -lt 0 ]; then s+=(-)
  else s+=(0)
  fi
done
echo "${s[0]}"
echo "${s[1]}"
echo "${s[2]}"
pat="${s[0]}${s[1]}${s[2]}"
case $pat in
  *0*) echo "con ceros" ;;
  +++) echo "todos positivos" ;;
  ---) echo "todos negativos" ;;
  *) echo mixto ;;
esac

