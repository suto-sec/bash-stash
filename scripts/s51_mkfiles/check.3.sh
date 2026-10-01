# checker spec for s51 step 3 (see lib/engine.sh)
SCRIPT_NAME=mkfiles.sh
setup() { echo old > report2; mkdir adir1; }
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *mkfiles.sh* ]]; }
ARGS=('log 3' 'report 3' 'report 1' 'report 5' 'adir 1' 'log' 'log x' 'a/b 2' '')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 4 ]] && mentions "$(eval "set -- $CASE"; for ((i = 1; i <= $2; i++)); do [[ -e $1$i ]] && { echo "$1$i"; break; }; done)"
}
