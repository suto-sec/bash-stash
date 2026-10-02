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
if (( $# < 1 || $# > 2 )); then echo "Error: wrong number of arguments" >&2; echo "Usage: $0 [path] [ip]" >&2; exit 1; fi
if (( $# == 2 )); then
  [[ -d $1 ]] || { echo "Error: $1 is not a directory" >&2; exit 3; }
  [[ $2 =~ $ip_re ]] || { echo "Error: $2 is not an IP address" >&2; exit 4; }
  list "$1" "$2"
  exit 0
fi
if [[ $1 =~ $ip_re ]]; then
  [[ -f $HOME/auth.log ]] || { echo "Error: $HOME/auth.log does not exist" >&2; exit 2; }
  n=$(grep -c -w -F -- "$1" "$HOME/auth.log")
  echo "$1 appears in $n lines"
elif [[ -d $1 ]]; then
  [[ -f $HOME/auth.log ]] || { echo "Error: $HOME/auth.log does not exist" >&2; exit 2; }
  last=$(grep -oE '[0-9]+(\.[0-9]+){3}' "$HOME/auth.log" | tail -n 1)
  echo "Last IP: $last"
  list "$1" "$last"
else
  echo "Error: $1 is neither an IP address nor a directory" >&2; exit 4
fi
