# checker spec for s08 step 2 (see lib/engine.sh)
SCRIPT_NAME=vowels.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *vowels.sh* ]]; }
ARGS=('Banana' '"hello big world"' '' 'one two' 'a b c')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
