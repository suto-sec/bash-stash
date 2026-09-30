# checker spec for 1314 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=skip.sh
COMPARE="stdout stderr exit"
ARGS=('' '2 a b c d' '0 a "b c"' '3 a b' '3 "x y" b c' 'x a' '-1 a' '1' '1 "*" "  sp  " last')
extra_check() { must_use shift; }
