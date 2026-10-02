#!/bin/bash
both=
if [[ $1 == -b ]]; then both=1; shift; fi
if (( $# != 2 )); then echo "Error: two arguments needed" >&2; echo "Usage: $0 [-b] dir1 dir2" >&2; exit 1; fi
for d in "$1" "$2"; do [[ -e $d ]] || { echo "Error: $d does not exist" >&2; exit 2; }; done
for d in "$1" "$2"; do [[ -d $d ]] || { echo "Error: $d is not a directory" >&2; exit 3; }; done
a=$(comm -23 <(ls "$1" | sort) <(ls "$2" | sort)); b=$(comm -13 <(ls "$1" | sort) <(ls "$2" | sort))
na=0 nb=0
[[ -n $a ]] && na=$(echo "$a" | wc -l)
[[ -n $b ]] && nb=$(echo "$b" | wc -l)
if [[ -z $both ]]; then
  [[ -n $a ]] && echo "$a"
  if (( na == 0 )); then echo "Nothing only in $1"; exit 4; fi
  echo "$na only in $1"
  exit 0
fi
{ [[ -n $a ]] && echo "$a" | sed 's/^/< /' ; [[ -n $b ]] && echo "$b" | sed 's/^/> /'; } | sort -k2
if (( na == 0 && nb == 0 )); then echo "The names are the same"; exit 4; fi
echo "$na only in $1, $nb only in $2"
