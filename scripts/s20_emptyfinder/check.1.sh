# checker spec for s20 step 1 (see lib/engine.sh)
SCRIPT_NAME=emptyfinder.sh
setup() {
  mkdir -p tree/a/deep tree/b tree/full "my tree/empty dir" none
  : > tree/zero.txt; : > tree/a/nothing.log; echo data > tree/full/data.txt; echo d > tree/b/b.txt; : > "my tree/blank file"
  echo x > "my tree/has data"; echo x > notadir.txt
}
usage_ok() { [[ $ERR == *sage* || $ERR == *Uso* || $ERR == *uso* || $ERR == *emptyfinder.sh* ]]; }
SORT_OUTPUT=1
ARGS=('tree' '"my tree"' 'none')
COMPARE="stdout exit"
