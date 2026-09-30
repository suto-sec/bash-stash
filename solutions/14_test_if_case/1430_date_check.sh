#!/bin/bash
# datecheck.sh date... | datecheck.sh -   - validate YYYY-MM-DD dates

if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") date... | $(basename "$0") -" >&2
  exit 2
fi

dates=()
if [ $# -eq 1 ] && [ "$1" = "-" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] && dates+=("$line")
  done
else
  dates=("$@")
fi

check() { # date -> "ok" or "invalid <what>"
  if [[ ! $1 =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]]; then echo "invalid format"; return; fi
  local y=$((10#${BASH_REMATCH[1]})) m=$((10#${BASH_REMATCH[2]})) d=$((10#${BASH_REMATCH[3]})) max
  if [ $y -lt 1900 ] || [ $y -gt 2099 ]; then echo "invalid year"; return; fi
  if [ $m -lt 1 ] || [ $m -gt 12 ]; then echo "invalid month"; return; fi
  case $m in
    4 | 6 | 9 | 11) max=30 ;;
    2) if (( (y % 4 == 0 && y % 100 != 0) || y % 400 == 0 )); then max=29; else max=28; fi ;;
    *) max=31 ;;
  esac
  if [ $d -lt 1 ] || [ $d -gt $max ]; then echo "invalid day"; return; fi
  echo ok
}

v=0 i=0
for dt in "${dates[@]}"; do
  r=$(check "$dt")
  echo "$dt: $r"
  if [ "$r" = ok ]; then v=$((v + 1)); else i=$((i + 1)); fi
done
echo "$v valid, $i invalid"
[ $i -eq 0 ] || exit 1

