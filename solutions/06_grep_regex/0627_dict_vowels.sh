#!/bin/bash
D=/usr/share/dict/words
grep -E '^[a-z]*a[a-z]*e[a-z]*i[a-z]*o[a-z]*u[a-z]*$' "$D"
echo ---
grep -E '^[b-df-hj-np-tv-z]{6,}$' "$D"
echo ---
grep -cE '^([a-z]{2})[a-z]+\1$' "$D"

