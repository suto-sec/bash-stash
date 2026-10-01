Write `maxnum.sh N...`. It prints the biggest of the integers it receives (at least one, possibly negative): `maxnum.sh 3 9 4` prints `9`.

Start with the first number as the biggest so far, then compare each other one: `if (( n > max )); then max=$n; fi`.
