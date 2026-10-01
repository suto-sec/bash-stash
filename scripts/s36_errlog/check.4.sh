# checker spec for s36 step 4 (see lib/engine.sh)
SCRIPT_NAME=errlog.sh
setup() {
  local i
  for ((i = 0; i < 20; i++)); do echo "2024-05-0$(randr 1 9) 1$(rand 10):$(randr 10 59):00 $(pick INFO INFO WARN ERROR INFO ERROR) $(words 3)"; done > app.log
  for ((i = 0; i < 5; i++)); do echo "2024-05-01 10:0$i:00 INFO $(words 2)"; done > calm.log
  : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *errlog.sh* ]]; }
pre_rep() { mkdir -p "$H/reports"; }
ARGS=('app.log' 'app.log $(pre_rep)' 'calm.log' 'empty.log $(pre_rep)' '' 'app.log calm.log' 'nothing.log' 'adir' 'locked.log')
COMPARE="stdout exit errmsg files"
extra_check() {
  [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }
  [[ $REF_CODE == 2 ]] && mentions "$(eval "set -- $CASE"; echo "$1")"
}
