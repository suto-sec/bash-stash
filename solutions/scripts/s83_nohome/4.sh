#!/bin/bash
all=
if [[ $1 == -a ]]; then all=1; shift; fi
if (( $# != 1 )); then echo "Error: one argument needed" >&2; echo "Usage: $0 [-a] passwdfile" >&2; exit 1; fi
[[ -e $1 ]] || { echo "Error: $1 does not exist" >&2; exit 2; }
[[ -f $1 ]] || { echo "Error: $1 is not a regular file" >&2; exit 3; }
n=0
while IFS=: read -r user _ uid _ _ home _; do
  if [[ -z $all ]] && ! (( uid >= 1000 && uid < 65534 )); then continue; fi
  if [[ ! -e $home ]]; then echo "$user: missing"; n=$((n + 1))
  elif [[ ! -d $home ]]; then echo "$user: not a directory"; n=$((n + 1))
  fi
done < "$1"
echo "$n problems"
(( n == 0 )) || exit 4
