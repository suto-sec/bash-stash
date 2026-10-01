# checker spec for s51 step 2 (see lib/engine.sh)
SCRIPT_NAME=mkfiles.sh
setup() { echo old > report2; mkdir adir1; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *mkfiles.sh* ]]; }
ARGS=('log 3' 'x 1' '' 'log' 'a b c' 'log 0' 'log x' 'log -2' 'a/b 2' '/tmp/x 2' 'a/b x')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
