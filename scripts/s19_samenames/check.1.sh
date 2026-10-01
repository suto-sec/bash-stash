# checker spec for s19 step 1 (see lib/engine.sh)
SCRIPT_NAME=samenames.sh
setup() {
  mkdir -p left right empty; local n
  for n in alpha bravo "two words" charlie; do echo l > "left/$n.txt"; done
  for n in bravo "two words" delta echo; do echo r > "right/$n.txt"; done
  echo x > left/only_left; mkdir left/sub right/sub; echo z > left/sub/inner.txt; echo x > right/charlie.txt
  echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *samenames.sh* ]]; }
SORT_OUTPUT=1
ARGS=('left right' 'right left' 'left empty' 'left left')
COMPARE="stdout exit"
