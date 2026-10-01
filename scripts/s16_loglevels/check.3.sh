# checker spec for s16 step 3 (see lib/engine.sh)
SCRIPT_NAME=loglevels.sh
setup() {
  local i
  for ((i = 0; i < 25; i++)); do echo "2024-03-0$(randr 1 9) 1$(rand 10):$(randr 10 59):$(randr 10 59) $(pick INFO INFO WARN ERROR INFO) $(words 3)"; done > app.log
  for ((i = 0; i < 6; i++)); do echo "2024-04-01 09:0$i:00 INFO $(words 2)"; done > calm.log
  : > empty.log; echo "x" > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *loglevels.sh* ]]; }
ARGS=('app.log' 'calm.log' '' 'app.log calm.log' 'nothing.log' 'adir' 'locked.log')
COMPARE="stdout exit errmsg"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
