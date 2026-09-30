#!/bin/bash
# pwcheck.sh [minlen] - rate the passwords read from stdin

if [ $# -gt 1 ]; then
  echo "Usage: $(basename "$0") [minlen]" >&2
  exit 2
fi
min=${1:-8}
if [[ ! $min =~ ^[1-9][0-9]*$ ]] || [ "$min" -lt 4 ] || [ "$min" -gt 64 ]; then
  echo "Error: invalid minimum length '$min' (4-64)" >&2
  exit 3
fi

s=0 m=0 w=0 r=0
while IFS= read -r pw; do
  [ -z "$pw" ] && continue
  if [[ $pw == *" "* ]]; then
    echo "$pw: rejected (spaces)"; r=$((r + 1)); continue
  fi
  if [ ${#pw} -lt "$min" ]; then
    echo "$pw: rejected (too short)"; r=$((r + 1)); continue
  fi
  score=0
  [[ $pw =~ [[:lower:]] ]] && score=$((score + 1))
  [[ $pw =~ [[:upper:]] ]] && score=$((score + 1))
  [[ $pw =~ [[:digit:]] ]] && score=$((score + 1))
  [[ $pw =~ [^[:alnum:]] ]] && score=$((score + 1))
  case $score in
    4) label=strong; s=$((s + 1)) ;;
    3) label=medium; m=$((m + 1)) ;;
    *) label=weak; w=$((w + 1)) ;;
  esac
  echo "$pw: $label ($score/4)"
done
echo "strong $s, medium $m, weak $w, rejected $r"
[ $((w + r)) -eq 0 ] || exit 1

