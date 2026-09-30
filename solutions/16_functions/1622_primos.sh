#!/bin/bash
# primos.sh N...
if [ $# -eq 0 ]; then
  echo "usage: $(basename "$0") N..." >&2
  exit 1
fi

es_primo() {
  local n=$1 d=${2:-2}
  if (( d * d > n )); then return 0; fi
  if (( n % d == 0 )); then return 1; fi
  es_primo "$n" $((d + 1))
}

primos=0
validos=0
for n in "$@"; do
  if [[ ! $n =~ ^[0-9]+$ ]] || [ "$n" -lt 2 ]; then
    echo "primos.sh: '$n' invalido" >&2
    continue
  fi
  validos=$((validos + 1))
  if es_primo "$n"; then
    echo "$n: primo"
    primos=$((primos + 1))
  else
    echo "$n: no primo"
  fi
done
echo "TOTAL: $primos primos de $validos validos"
[ "$validos" -gt 0 ] || exit 2

