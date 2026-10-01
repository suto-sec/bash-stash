# checker spec for s57 step 3 (see lib/engine.sh)
SCRIPT_NAME=setexec.sh
setup() {
  echo a > run.sh; chmod 644 run.sh; echo b > tool.sh; chmod 755 tool.sh; echo c > "my script.sh"; chmod 600 "my script.sh"
  echo d > notes.txt; chmod 640 notes.txt; mkdir adir; echo e > ro.sh; chmod 444 ro.sh
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *setexec.sh* ]]; }
ARGS=('run.sh' '-a run.sh' '-a run.sh tool.sh "my script.sh"' '-a notes.txt' '-a' '' '-a nothing.sh run.sh' 'nothing.sh')
COMPARE="stdout exit errmsg files"
extra_check() { [[ $REF_CODE == 1 ]] && { usage_ok || fail "the message should show the correct usage"; }; }
