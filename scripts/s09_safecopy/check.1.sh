# checker spec for s09 step 1 (see lib/engine.sh)
SCRIPT_NAME=safecopy.sh
setup() {
  echo "one" > a.txt; echo "two words" > "my file.txt"; echo "three" > b.txt
  mkdir out sub; echo "old" > out/b.txt; echo "x" > out/keep.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *safecopy.sh* ]]; }
ARGS=('a.txt copy.txt' '"my file.txt" out/new.txt' 'b.txt sub/b2.txt')
COMPARE="stdout exit files"
