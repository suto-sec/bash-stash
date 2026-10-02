#!/bin/bash
ip_re='^[0-9]+(\.[0-9]+){3}$'
list() {
  local f n
  for f in "$1"/*.log; do
    [[ -f $f ]] || continue
    n=$(grep -c -w -F -- "$2" "$f")
    (( n > 0 )) && echo "$(basename "$f"): $n"
  done
  return 0
}
if (( $# == 1 )); then
  if [[ $1 =~ $ip_re ]]; then
    n=$(grep -c -w -F -- "$1" "$HOME/auth.log")
    echo "$1 appears in $n lines"
  else
    last=$(grep -oE '[0-9]+(\.[0-9]+){3}' "$HOME/auth.log" | tail -n 1)
    echo "Last IP: $last"
    list "$1" "$last"
  fi
  exit 0
fi
list "$1" "$2"
