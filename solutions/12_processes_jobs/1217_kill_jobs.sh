#!/bin/bash
[ $# -ge 1 ] || { echo "Usage: $(basename "$0") SPEC..." >&2; exit 1; }
for t in "$@"; do
  case $t in
    %1|%2|%3|all) ;;
    *) echo "Error: invalid spec '$t'" >&2; exit 2 ;;
  esac
done

sleep 301 & J1=$!
sleep 302 & J2=$!
sleep 303 & J3=$!

T1=0; T2=0; T3=0
for t in "$@"; do
  case $t in
    all) T1=1; T2=1; T3=1 ;;
    %1)  T1=1 ;;
    %2)  T2=1 ;;
    %3)  T3=1 ;;
  esac
done

kill "$J1" "$J2" "$J3" 2>/dev/null
wait "$J1" "$J2" "$J3" 2>/dev/null

[ "$T1" = 1 ] && echo "job 1: killed by spec" || echo "job 1: not in spec"
[ "$T2" = 1 ] && echo "job 2: killed by spec" || echo "job 2: not in spec"
[ "$T3" = 1 ] && echo "job 3: killed by spec" || echo "job 3: not in spec"
echo "targeted: $((T1 + T2 + T3)) of 3"

