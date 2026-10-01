# checker spec for s18 step 1 (see lib/engine.sh)
SCRIPT_NAME=tailn.sh
setup() {
  local i
  for ((i = 1; i <= 20; i++)); do echo "line $i $(word)"; done > long.txt
  for ((i = 1; i <= 3; i++)); do echo "short $i"; done > short.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *tailn.sh* ]]; }
ARGS=('long.txt' 'short.txt' 'empty.txt')
COMPARE="stdout exit"
