# checker spec for s18 step 4 (see lib/engine.sh)
SCRIPT_NAME=tailn.sh
setup() {
  local i
  for ((i = 1; i <= 20; i++)); do echo "line $i $(word)"; done > long.txt
  for ((i = 1; i <= 3; i++)); do echo "short $i"; done > short.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *tailn.sh* ]]; }
ARGS=('long.txt' 'long.txt 2' 'short.txt 10' 'empty.txt' '' 'nothing.txt' 'long.txt x')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
  [[ $REF_CODE == 3 ]] && mentions "$(eval "set -- $CASE"; echo "$2")"
}
