# checker spec for 1419 (see lib/engine.sh)
SEEDS=1
SCRIPT_NAME=cmp2.sh
COMPARE="stdout stderr exit"
ARGS=('10 9' '9 10' '007 7' '5 5' '100 99' '12 12' '0 00' '3 30' '2 11' '' '1' 'a 1' '1 -2' '1 2 3')
extra_check() { ans_code | grep -qE -- '-lt|-gt' || fail "compare the numbers with -lt / -gt"; }
