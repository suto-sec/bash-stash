# checker spec for s77 step 1 (see lib/engine.sh)
SCRIPT_NAME=onlyin.sh
setup() {
  mkdir -p d1 d2 same1 same2 "my one" "my two" empty
  touch d1/a d1/b d1/c d1/d "d1/two words" d1/.hid d1/shared.txt
  touch d2/b d2/c d2/e "d2/two words" d2/shared.txt d2/zeta
  touch same1/x same1/y same2/x same2/y
  touch "my one/p" "my one/q" "my two/q" "my two/r"
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *onlyin.sh* ]]; }
ARGS=('d1 d2' 'd2 d1' 'same1 same2' '"my one" "my two"' 'empty d1' 'd1 empty')
COMPARE="stdout exit"
