# checker spec for s49 step 1 (see lib/engine.sh)
SCRIPT_NAME=words.sh
setup() {
  mkfl poem.txt "the quick brown fox" "jumps" "" "over   the lazy   dog" "end"
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *words.sh* ]]; }
ARGS=('poem.txt' 'empty.txt')
COMPARE="stdout exit"
