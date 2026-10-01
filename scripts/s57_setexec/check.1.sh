# checker spec for s57 step 1 (see lib/engine.sh)
SCRIPT_NAME=setexec.sh
setup() {
  echo a > run.sh; chmod 644 run.sh; echo b > tool.sh; chmod 755 tool.sh; echo c > "my script.sh"; chmod 600 "my script.sh"
  echo d > notes.txt; chmod 640 notes.txt; mkdir adir; echo e > ro.sh; chmod 444 ro.sh
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *setexec.sh* ]]; }
ARGS=('run.sh' 'run.sh tool.sh' '"my script.sh" notes.txt' 'ro.sh')
COMPARE="stdout exit files"
