# checker spec for s55 step 1 (see lib/engine.sh)
SCRIPT_NAME=uniqlines.sh
setup() {
  mkfl words.txt "pear" "apple" "pear" "fig" "apple" "pear" "kiwi"
  mkfl one.txt "same" "same" "same"; : > empty.txt; echo x > locked.txt; chmod 000 locked.txt; mkdir adir
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *uniqlines.sh* ]]; }
ARGS=('words.txt' 'one.txt' 'empty.txt')
COMPARE="stdout exit"
