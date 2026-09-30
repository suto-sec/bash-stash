# checker spec for 1316 (see lib/engine.sh)
SEEDS=1
COMPARE="stdout stderr exit"
ARGS=('' 'name pepe' 'a 1 b 2 "c d" "3 4"' 'a 1 b' '"" x' 'a 1 "" 2 "" 3' 'k ""' 'x' 'k1 "" k2 v2')
extra_check() { must_use shift; }
