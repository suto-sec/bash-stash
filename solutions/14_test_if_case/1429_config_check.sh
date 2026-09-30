#!/bin/bash
# config_check.sh file - validate a key=value configuration file

if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") file" >&2
  exit 2
fi
file=$1
if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  echo "Error: '$file' is not a readable regular file" >&2
  exit 3
fi

p=0
seen=" "      # keys already seen, separated by spaces
num=0
problem() { echo "$1"; p=$((p + 1)); }

while IFS= read -r line; do
  num=$((num + 1))
  [ -z "$line" ] && continue
  [[ $line == \#* ]] && continue
  if [[ ! $line =~ ^([a-z_]+)=(.*)$ ]]; then
    problem "line $num: syntax error"
    continue
  fi
  k=${BASH_REMATCH[1]} v=${BASH_REMATCH[2]}
  if [[ $seen == *" $k "* ]]; then
    problem "line $num: duplicate key '$k'"
    continue
  fi
  seen+="$k "
  ok=1
  case $k in
    port)   [[ $v =~ ^[1-9][0-9]*$ ]] && [ "$v" -le 65535 ] || ok=0 ;;
    mode)   [ "$v" = on ] || [ "$v" = off ] || ok=0 ;;
    name)   [[ -n $v && $v != *" "* ]] || ok=0 ;;
    logdir) [ -d "$v" ] || ok=0 ;;
    level)
      case $v in
        debug | info | warn | error) ;;
        *) ok=0 ;;
      esac
      ;;
    *) problem "line $num: unknown key '$k'"; continue ;;
  esac
  [ $ok -eq 1 ] || problem "line $num: bad value for $k: '$v'"
done < "$file"

for k in name port; do
  [[ $seen == *" $k "* ]] || problem "missing key: $k"
done
if [ $p -eq 0 ]; then
  echo OK
else
  echo "$p problems"
  exit 1
fi

