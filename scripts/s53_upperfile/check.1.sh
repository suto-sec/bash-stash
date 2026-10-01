# checker spec for s53 step 1 (see lib/engine.sh)
SCRIPT_NAME=upperfile.sh
setup() {
  mkfl notes.txt "hello world" "second Line" "" "last one"; echo "two words" > "my file.txt"; : > empty.txt
  echo x > locked.txt; chmod 000 locked.txt; mkdir adir; echo "old copy" > old.txt.upper; echo "old text" > old.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *upperfile.sh* ]]; }
ARGS=('notes.txt' '"my file.txt"' 'empty.txt')
COMPARE="stdout exit files"
