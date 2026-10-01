# checker spec for s06 step 2 (see lib/engine.sh)
SCRIPT_NAME=countdown.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *countdown.sh* ]]; }
ARGS=('3' '1' '10' '' '3 4' 'abc' '0' '-2' '2x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
