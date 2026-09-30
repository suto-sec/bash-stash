#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") action path" >&2
  exit 2
fi
p=$2
case $1 in
  read)   [ -f "$p" ] && [ -r "$p" ] ;;
  write)  [ -f "$p" ] && [ -w "$p" ] ;;
  run)    [ -f "$p" ] && [ -x "$p" ] ;;
  enter)  [ -d "$p" ] && [ -x "$p" ] ;;
  list)   [ -d "$p" ] && [ -r "$p" ] ;;
  create) d=$(dirname "$p"); [ ! -e "$p" ] && [ -d "$d" ] && [ -w "$d" ] && [ -x "$d" ] ;;
  *)      echo "unknown action: $1" >&2; exit 2 ;;
esac
if [ $? -eq 0 ]; then
  echo yes
else
  echo no
  exit 1
fi

