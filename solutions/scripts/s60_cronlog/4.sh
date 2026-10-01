#!/bin/bash
user=
if [[ $1 == -u ]]; then
  if (( $# != 3 )); then echo "Error: -u needs a user and a log" >&2; echo "Usage: $0 [-u user] log" >&2; exit 1; fi
  user=$2; shift 2
fi
if (( $# != 1 )); then echo "Error: one log is needed" >&2; echo "Usage: $0 [-u user] log" >&2; exit 1; fi
[[ -f $1 && -r $1 ]] || { echo "Error: cannot read $1" >&2; exit 2; }
if [[ -n $user ]]; then
  n=0
  while read -r -a w; do
    [[ " ${w[*]} " == *" CMD "* ]] || continue
    [[ ${w[5]} == "($user)" ]] || continue
    c=${w[*]:7}; c=${c#(}; c=${c%)}
    echo "$c"; n=$((n + 1))
  done < "$1"
  echo "Jobs: $n"
  exit 0
fi
declare -A n
while read -r -a w; do
  [[ " ${w[*]} " == *" CMD "* ]] || continue
  u=${w[5]#(}; u=${u%)}
  n[$u]=$(( ${n[$u]:-0} + 1 ))
done < "$1"
for u in $(printf '%s\n' "${!n[@]}" | sort); do echo "$u: ${n[$u]}"; done
echo "Jobs: $(grep -c ' CMD (' "$1")"
