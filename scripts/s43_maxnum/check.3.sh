# checker spec for s43 step 3 (see lib/engine.sh)
SCRIPT_NAME=maxnum.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *maxnum.sh* ]]; }
ARGS=('5' '3 9 4' '-5 -2 -9' '10 10 10' '' 'x 1')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "x"
}
