# checker spec for s53 step 4 (see lib/engine.sh)
SCRIPT_NAME=upperfile.sh
setup() {
  mkfl notes.txt "hello world" "second Line" "" "last one"; echo "two words" > "my file.txt"; : > empty.txt
  echo x > locked.txt; chmod 000 locked.txt; mkdir adir; echo "old copy" > old.txt.upper; echo "old text" > old.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *upperfile.sh* ]]; }
ARGS=('notes.txt' 'old.txt' '-f notes.txt' '-f old.txt' '-f "my file.txt"' '-f' '' '-f nothing.txt' '-f locked.txt' 'nothing.txt')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "${@: -1}")"
  [[ $REF_CODE == 3 ]] && mentions "old.txt.upper"
}
