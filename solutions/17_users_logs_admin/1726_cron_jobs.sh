#!/bin/bash
# cronjobs.sh [file] - list the jobs of a crontab
[ $# -le 1 ] || { echo "Usage: $(basename "$0") [file]" >&2; exit 2; }
if [ $# -eq 1 ]; then
  [ -f "$1" ] && [ -r "$1" ] || { echo "Error: cannot read $1" >&2; exit 1; }
  TAB=$(cat "$1")
else
  TAB=$(crontab -l 2>/dev/null)
fi

N=0
while read -r first rest; do
  case $first in
    ''|'#'*) continue ;;
  esac
  [[ $first =~ ^[A-Za-z_][A-Za-z0-9_]*= ]] && continue
  if [[ $first == @* ]]; then
    echo "$first -> $rest"
  else
    read -r h dom mon dow cmd <<< "$rest"
    echo "$first $h $dom $mon $dow -> $cmd"
  fi
  N=$((N + 1))
done <<< "$TAB"
echo "$N jobs"

