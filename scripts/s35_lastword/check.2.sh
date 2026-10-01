# checker spec for s35 step 2 (see lib/engine.sh)
SCRIPT_NAME=lastword.sh
setup() {
  mkfl poem.txt "the quick brown fox" "jumps over" "" "lazy" "dogs bark   loudly  "
  : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *lastword.sh* ]]; }
ARGS=('poem.txt' 'empty.txt')
COMPARE="stdout exit"
