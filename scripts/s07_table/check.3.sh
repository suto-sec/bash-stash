# checker spec for s07 step 3 (see lib/engine.sh)
SCRIPT_NAME=table.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *table.sh* ]]; }
ARGS=('7' '3 4' '5 1' '2 12' '' '1 2 3' 'abc' '3 0' '3 x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; echo "$@"); do [[ $a =~ ^[0-9]+$ ]] || mentions "$a"; done; }
}
