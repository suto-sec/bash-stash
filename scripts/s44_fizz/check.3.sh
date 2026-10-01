# checker spec for s44 step 3 (see lib/engine.sh)
SCRIPT_NAME=fizz.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *fizz.sh* ]]; }
ARGS=('1' '5' '15' '30' '' 'x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "x"
}
