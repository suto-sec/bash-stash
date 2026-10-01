# checker spec for s36 step 2 (see lib/engine.sh)
SCRIPT_NAME=errlog.sh
setup() {
  local i
  for ((i = 0; i < 20; i++)); do echo "2024-05-0$(randr 1 9) 1$(rand 10):$(randr 10 59):00 $(pick INFO INFO WARN ERROR INFO ERROR) $(words 3)"; done > app.log
  for ((i = 0; i < 5; i++)); do echo "2024-05-01 10:0$i:00 INFO $(words 2)"; done > calm.log
  : > empty.log; echo x > locked.log; chmod 000 locked.log; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *errlog.sh* ]]; }
pre_rep() { mkdir -p "$H/reports"; }
ARGS=('app.log $(pre_rep)' 'calm.log $(pre_rep)' 'empty.log $(pre_rep)')
COMPARE="stdout exit files"
