# checker spec for s61 step 3 (see lib/engine.sh)
SCRIPT_NAME=timelog.sh
setup() {
  local i
  for ((i = 0; i < 30; i++)); do printf '%02d:%02d:%02d %s\n' "$(pick 8 8 9 10 10 10 14 23)" "$(rand 60)" "$(rand 60)" "$(words 2)"; done > events.log
  mkfl one.log "07:15:00 started"; : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *timelog.sh* ]]; }
ARGS=('events.log' 'empty.log' '' 'events.log one.log' 'nothing.log' 'adir' 'locked.log')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
