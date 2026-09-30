#!/bin/bash
# ip_classify.sh ip... | -f file - classify IPv4 addresses

usage() {
  echo "Usage: $(basename "$0") ip... | $(basename "$0") -f file" >&2
  exit 2
}

classify() { # ip -> class
  local o='(0|[1-9][0-9]{0,2})' a b
  if [[ ! $1 =~ ^$o\.$o\.$o\.$o$ ]]; then echo invalid; return; fi
  a=${BASH_REMATCH[1]} b=${BASH_REMATCH[2]}
  local i
  for i in 1 2 3 4; do
    [ "${BASH_REMATCH[i]}" -le 255 ] || { echo invalid; return; }
  done
  if [ "$a" -eq 127 ]; then echo loopback
  elif [ "$a" -eq 10 ] || { [ "$a" -eq 172 ] && [ "$b" -ge 16 ] && [ "$b" -le 31 ]; } ||
       { [ "$a" -eq 192 ] && [ "$b" -eq 168 ]; }; then echo private
  elif [ "$a" -eq 169 ] && [ "$b" -eq 254 ]; then echo link-local
  elif [ "$a" -ge 224 ] && [ "$a" -le 239 ]; then echo multicast
  elif [ "$a" -eq 0 ] || [ "$a" -ge 240 ]; then echo reserved
  else echo public
  fi
}

[ $# -ge 1 ] || usage
ips=()
if [ "$1" = "-f" ]; then
  [ $# -eq 2 ] || usage
  if [ ! -f "$2" ] || [ ! -r "$2" ]; then
    echo "Error: '$2' is not a readable regular file" >&2
    exit 3
  fi
  while IFS= read -r line; do
    [ -n "$line" ] && ips+=("$line")
  done < "$2"
else
  ips=("$@")
fi

v=0 inv=0
for ip in "${ips[@]}"; do
  c=$(classify "$ip")
  echo "$ip: $c"
  if [ "$c" = invalid ]; then inv=$((inv + 1)); else v=$((v + 1)); fi
done
echo "${#ips[@]} addresses: $v valid, $inv invalid"
[ $inv -eq 0 ] || exit 1

