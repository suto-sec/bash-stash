# checker spec for s55 step 3 (see lib/engine.sh)
SCRIPT_NAME=uniqlines.sh
setup() {
  mkfl words.txt "pear" "apple" "pear" "fig" "apple" "pear" "kiwi"
  mkfl one.txt "same" "same" "same"; : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *uniqlines.sh* ]]; }
ARGS=('words.txt' 'empty.txt' '' 'words.txt one.txt' 'nothing.txt' 'adir' 'locked.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
