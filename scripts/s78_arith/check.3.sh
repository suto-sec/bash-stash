# checker spec for s78 step 3 (see lib/engine.sh)
SCRIPT_NAME=arith.sh
setup() { mkdir -p dir; echo x > file.txt; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *arith.sh* ]]; }
ARGS=('7 + 5' '7 - 12' '7 x 6' '-4 x 5' '17 / 5' '-17 / 5' '17 % 5' '' '1 + 2 3' 'abc + 1' '1 + xyz' '5 ^ 2' '5 / 0' '5 % 0')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  if [[ $REF_CODE == 2 ]]; then
    local bad; bad=$(eval "set -- $CASE"; [[ $1 =~ ^-?[0-9]+$ ]] && echo "$3" || echo "$1"); mentions "$bad"
  fi
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
