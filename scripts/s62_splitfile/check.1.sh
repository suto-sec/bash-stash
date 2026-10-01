# checker spec for s62 step 1 (see lib/engine.sh)
SCRIPT_NAME=splitfile.sh
setup() {
  local i
  for ((i = 1; i <= 10; i++)); do echo "line $i $(word)"; done > ten.txt
  for ((i = 1; i <= 3; i++)); do echo "short $i"; done > three.txt
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir; echo "old" > ten.txt.part2
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *splitfile.sh* ]]; }
ARGS=('three.txt 2' 'three.txt 1' 'three.txt 5' 'empty.txt 3')
COMPARE="stdout exit files"
