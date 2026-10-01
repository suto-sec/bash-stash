# checker spec for s06 step 3 (see lib/engine.sh)
SCRIPT_NAME=countdown.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *countdown.sh* ]]; }
ARGS=('3' '10 3' '10 4' '5 5' '7 1' '' '3 4 5' 'abc' '5 0' '5 x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; echo "$@"); do [[ $a =~ ^[1-9][0-9]*$ ]] || mentions "$a"; done; }
}
