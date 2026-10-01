# checker spec for s50 step 3 (see lib/engine.sh)
SCRIPT_NAME=grade.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *grade.sh* ]]; }
ARGS=('95' '95 82 71 65 10' '100 100' '59 60' '' '90 x 80' '50 101')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && { local a; for a in $(eval "set -- $CASE"; echo "$@"); do [[ $a =~ ^[0-9]+$ ]] && (( a <= 100 )) || { mentions "$a"; break; }; done; }
}
