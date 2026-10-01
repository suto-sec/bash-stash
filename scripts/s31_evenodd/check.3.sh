# checker spec for s31 step 3 (see lib/engine.sh)
SCRIPT_NAME=evenodd.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *evenodd.sh* ]]; }
ARGS=('7' '1 2 3 4 5' '10 20 30' '' '4 x 6' 'abc' '2 -3')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; echo "$@"); do [[ $a =~ ^[0-9]+$ ]] || { mentions "$a"; break; }; done; }
}
