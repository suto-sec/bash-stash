# checker spec for s03 step 4 (see lib/engine.sh)
SCRIPT_NAME=sumargs.sh
setup() { :; }
ARGS=('5' '1 2 3' '10 20 30 40' '-5 3' '-7 -8 -9' '3 x 4' '' '1 -' '7 8')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { [[ $ERR == *sumargs.sh* || $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* ]] || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local bad; bad=$(eval "set -- $CASE"; for a in "$@"; do [[ $a =~ ^-?[0-9]+$ ]] || { echo "$a"; break; }; done); mentions "$bad"; }
}
