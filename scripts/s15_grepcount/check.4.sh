# checker spec for s15 step 4 (see lib/engine.sh)
SCRIPT_NAME=grepcount.sh
setup() {
  local i
  for ((i = 0; i < 12; i++)); do echo "$(pick Error Warning info ERROR error ok) $(word) $i"; done > a.log
  for ((i = 0; i < 7; i++)); do echo "$(pick Error info ok Warning) $(word) $i"; done > b.log
  : > empty.log; echo "locked error" > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *grepcount.sh* ]]; }
ARGS=('Error a.log' '-i error a.log' '-i error a.log b.log' 'Error nothing.log a.log' '-i error' '-i' '' 'Error locked.log')
COMPARE="stdout exit errmsg"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
