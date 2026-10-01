# checker spec for s43 step 2 (see lib/engine.sh)
SCRIPT_NAME=maxnum.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *maxnum.sh* ]]; }
ARGS=('5' '3 9 4' '-5 -2' '' 'a' '3 x 4' '2.5' '--3')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; echo "$@"); do [[ $a =~ ^-?[0-9]+$ ]] || { mentions "$a"; break; }; done; }
}
