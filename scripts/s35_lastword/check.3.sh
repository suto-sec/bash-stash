# checker spec for s35 step 3 (see lib/engine.sh)
SCRIPT_NAME=lastword.sh
setup() {
  mkfl poem.txt "the quick brown fox" "jumps over" "" "lazy" "dogs bark   loudly  "
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *lastword.sh* ]]; }
ARGS=('poem.txt' '' 'poem.txt empty.txt' 'nothing.txt' 'adir' 'locked.txt')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
