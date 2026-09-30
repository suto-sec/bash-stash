#!/bin/bash
# notes.sh add <text>... | list | del <n> | count

F=$HOME/notes.txt

usage() {
  echo "Usage: $(basename "$0") add <text>... | list | del <n> | count" >&2
}
wrong_args() {
  echo "Error: wrong number of arguments for '$1'" >&2
  usage
  exit 3
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi
cmd=$1
shift

total=0
[ -f "$F" ] && total=$(wc -l < "$F")

case $cmd in
  add)
    [ $# -ge 1 ] || wrong_args add
    echo "$*" >> "$F"
    echo "Added note $((total + 1))"
    ;;
  list)
    [ $# -eq 0 ] || wrong_args list
    if [ "$total" -eq 0 ]; then
      echo "No notes"
    else
      n=0
      while IFS= read -r line; do
        n=$((n + 1))
        echo "$n: $line"
      done < "$F"
    fi
    ;;
  del)
    [ $# -eq 1 ] || wrong_args del
    if [[ ! $1 =~ ^[1-9][0-9]*$ ]] || [ "$1" -gt "$total" ]; then
      echo "Error: there is no note '$1'" >&2
      exit 4
    fi
    text=$(sed -n "${1}p" "$F")
    sed -i "${1}d" "$F"
    echo "Deleted note $1: $text"
    ;;
  count)
    [ $# -eq 0 ] || wrong_args count
    echo "$total notes"
    ;;
  *)
    echo "Error: unknown subcommand '$cmd'" >&2
    usage
    exit 2
    ;;
esac

