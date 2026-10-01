# checker spec for s08 step 3 (see lib/engine.sh)
SCRIPT_NAME=vowels.sh
setup() { :; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *vowels.sh* ]]; }
ARGS=('Banana' 'Banana rhythm AEIOU' '"hello big world" xyz' '' 'a e')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
